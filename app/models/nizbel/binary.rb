module Nizbel
  class Binary < ActiveRecord::Base
    attr_accessible :date, :group_id, :name, :poster, :release_id, :request_id, :total_parts, :binary_hash

    belongs_to :group
    has_many :parts, :order => :part_number
  end
end
