# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121215065357) do

  create_table "nizbel_groups", :force => true do |t|
    t.string   "name",                      :default => "",    :null => false
    t.integer  "backfill_target",           :default => 1,     :null => false
    t.integer  "first_record",              :default => 0,     :null => false
    t.datetime "first_record_postdate"
    t.integer  "last_record",               :default => 0,     :null => false
    t.datetime "last_record_postdate"
    t.datetime "last_updated"
    t.integer  "min_files_to_form_release"
    t.boolean  "active",                    :default => false, :null => false
    t.string   "description",               :default => ""
  end

end
