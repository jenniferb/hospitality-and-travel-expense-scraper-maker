# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20080819225932) do

  create_table "departments", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.boolean  "completed"
    t.string   "is_scrapeable"
    t.integer  "levels"
    t.integer  "split_level"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hospitality_details", :force => true do |t|
    t.integer  "department_id"
    t.string   "name"
    t.boolean  "completed"
    t.string   "url"
    t.string   "person_name_format"
    t.string   "date_format"
    t.string   "report_xpath"
    t.string   "person_name_and_position_xpath"
    t.string   "start_date",                     :default => "3"
    t.string   "end_date"
    t.string   "purpose",                        :default => "2"
    t.string   "location",                       :default => "4"
    t.string   "attendees",                      :default => "5"
    t.string   "total",                          :default => "6"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "name_inside_table",              :default => true

  end

  create_table "link_levels", :force => true do |t|
    t.integer  "department_id"
    t.string   "name"
    t.boolean  "completed"
    t.string   "url"
    t.integer  "level"
    t.string   "example_text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", :force => true do |t|
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "split_levels", :force => true do |t|
    t.integer  "department_id"
    t.string   "name"
    t.boolean  "completed"
    t.string   "url"
    t.integer  "level"
    t.string   "base_xpath"
    t.string   "hospitality_div_xpath", :default => "/table[2]"
    t.string   "travel_div_xpath",      :default => "/table[1]"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "travel_details", :force => true do |t|
    t.integer  "department_id"
    t.string   "name"
    t.boolean  "completed"
    t.string   "url"
    t.string   "person_name_format"
    t.string   "date_format"
    t.string   "report_xpath"
    t.string   "person_name_and_position_xpath", :default => "/tr[1]/td[2]"
    t.string   "expense_table_xpath"
    t.string   "start_date",                     :default => "3"
    t.string   "end_date"
    t.string   "purpose",                        :default => "2"
    t.string   "destinations",                   :default => "4"
    t.string   "airfare",                        :default => "5"
    t.string   "other_travel",                   :default => "6"
    t.string   "accomodation",                   :default => "7"
    t.string   "meals",                          :default => "8"
    t.string   "other",                          :default => "9"
    t.string   "total",                          :default => "10"
    t.boolean  "name_inside_table",              :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
