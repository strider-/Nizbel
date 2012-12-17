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

ActiveRecord::Schema.define(:version => 20121216232040) do

  create_table "categories_groups", :force => true do |t|
    t.integer "group_id"
    t.integer "category_id"
  end

  create_table "nizbel_binaries", :force => true do |t|
    t.string   "name"
    t.string   "poster"
    t.datetime "date"
    t.integer  "total_parts"
    t.integer  "group_id"
    t.integer  "request_id"
    t.string   "binary_hash"
    t.integer  "release_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "nizbel_binaries", ["binary_hash"], :name => "index_nizbel_binaries_on_binary_hash", :unique => true
  add_index "nizbel_binaries", ["date"], :name => "index_nizbel_binaries_on_date"
  add_index "nizbel_binaries", ["poster"], :name => "index_nizbel_binaries_on_poster"

  create_table "nizbel_categories", :force => true do |t|
    t.string  "title",                         :null => false
    t.string  "description"
    t.integer "parent_id"
    t.boolean "active",      :default => true
  end

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

  create_table "nizbel_parts", :force => true do |t|
    t.integer  "binary_id"
    t.string   "message_id"
    t.integer  "article_id"
    t.integer  "part_number"
    t.integer  "size"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "nizbel_release_regexes", :force => true do |t|
    t.text     "regex",                         :null => false
    t.boolean  "active",      :default => true, :null => false
    t.integer  "options",     :default => 0,    :null => false
    t.string   "description"
    t.integer  "category_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "nizbel_release_regexes", ["regex"], :name => "index_nizbel_release_regexes_on_regex", :unique => true

  create_table "nizbel_users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password_digest"
    t.integer  "role"
    t.integer  "nzb_grabs",       :default => 0, :null => false
    t.string   "token"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "nizbel_users", ["email"], :name => "index_nizbel_users_on_email", :unique => true
  add_index "nizbel_users", ["username"], :name => "index_nizbel_users_on_username", :unique => true

end
