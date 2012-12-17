module Nizbel
  class Category < ActiveRecord::Base
    attr_accessible :description, :parent_id, :status, :title

    has_and_belongs_to_many :groups
    has_many :release_regexes

    belongs_to :parent,
      :class_name => "Nizbel::Category"

    has_many :children,
      :class_name => "Nizbel::Category",
      :foreign_key => :parent_id,
      :order => :title

    def determine_category(release_name)
      categories = Set.new
      ReleaseRegex.by_category(self).each do |r|
        categories << [r.category, r.regex.length] if r.to_regexp =~ release_name
      end
      categories.sort { |a,b| a[1] <=> b[1] }.first.try(:[], 0)
    end

  end
end
