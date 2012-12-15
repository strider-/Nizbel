class CreateNizbelGroups < ActiveRecord::Migration
  def change
    create_table :nizbel_groups do |t|
      t.string   :name,                     :null => false, :default => ''
      t.integer  :backfill_target,          :null => false, :default => 1
      t.integer  :first_record,             :null => false, :default => 0
      t.datetime :first_record_postdate
      t.integer  :last_record,              :null => false, :default => 0
      t.datetime :last_record_postdate
      t.datetime :last_updated
      t.integer  :min_files_to_form_release
      t.boolean  :active,                   :null => false, :default => false
      t.string   :description,              :default => ''
    end
  end
end
