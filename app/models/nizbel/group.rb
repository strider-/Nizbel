module Nizbel
  class Group < ActiveRecord::Base
    attr_accessible :active, :backfill_target, :description, :first_record, :first_record_postdate,
                    :last_record, :last_record_postdate, :last_updated, :min_files_to_form_release, :name

    has_and_belongs_to_many :categories
    has_many :binaries

    scope :active, where(:active => true)

    def reset!
      self.backfill_target = 0
      self.first_record = 0
      self.first_record_postdate = nil
      self.last_record = 0
      self.last_record_postdate = nil
      self.last_updated = nil
      save!
    end
  end
end