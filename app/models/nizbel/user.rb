module Nizbel
  class User < ActiveRecord::Base
    attr_accessible :email, :password, :password_confirmation
    has_secure_password

    module Roles
      USER = 1
      ADMIN = 2
      DISABLED = 3
      def self.to_a; constants.map { |c| const_get(c) }; end
      def self.[](idx); Hash[to_a.zip(constants.map { |c| c.to_s.titlecase })][idx]; end
    end

    before_create :generate_token

    validates :username, :presence => true,
                         :uniqueness => { :case_sensitive => false }
    validates :email, :presence => true,
                      :format => { :with => /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                      :uniqueness => { :case_sensitive => false }
    validates :password, :length => { :minimum => 8 },
                         :on => :create
    validates :password_confirmation, :presence => true,
                                      :on => :create
    validates :role, :presence => true,
                     :inclusion => { :in => Roles.to_a, :message => 'not a valid user role!' }

    def generate_token
      self.token = SecureRandom.hex
    end

    def role_name
      Roles[self.role]
    end
  end
end
