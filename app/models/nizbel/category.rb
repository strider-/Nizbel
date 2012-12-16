module Nizbel
  class Category < ActiveRecord::Base
    attr_accessible :description, :parent_id, :status, :title

  has_and_belongs_to_many :groups

  belongs_to :parent,
    :class_name => "Category"
  has_many :children,
    :class_name => "Category",
    :foreign_key => :parent_id
  end
end
