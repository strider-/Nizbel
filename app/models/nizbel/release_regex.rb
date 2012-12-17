module Nizbel
  class ReleaseRegex < ActiveRecord::Base
    attr_accessible :active, :regex, :options, :description

    belongs_to :category

    validates :regex, :presence => true,
                      :uniqueness => { :case_sensitive => false }
    validate :good_regex

    scope :for_release_tagging, where(:active => true, :category_id => nil)
    scope :by_category, lambda { |category| where(:active => true, :category_id => [category, *category.children]) }

    def self.from_php_regex(php_regex_str)
      trailing_options = [/\/i?S?\s*$/, '']
      leading_slash = [/^\//, '']
      php_named_groups = [/\(\?P/, '(?']

      options = Regexp::IGNORECASE if php_regex_str.match(trailing_options[0])
      clean_regex = php_regex_str.gsub(*trailing_options).gsub(*leading_slash).gsub(*php_named_groups)

      ReleaseRegex.where(:regex => clean_regex).first_or_create.tap do |r|
        r.options = (options || 0)
      end
    end

    def to_regexp
      Regexp.new(self.regex, self.options) rescue nil
    end

    protected

    def good_regex
      errors.add(:regex, 'invalid expression!') if to_regexp.nil?
    end
  end
end