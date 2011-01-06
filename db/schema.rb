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

ActiveRecord::Schema.define(:version => 20110103164511) do

  create_table "activities", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "estimated_pomodoros"
    t.date     "deadline"
    t.boolean  "completed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["completed"], :name => "index_activities_on_completed"
  add_index "activities", ["deadline"], :name => "index_activities_on_deadline"

  create_table "dummies", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pomodoros", :force => true do |t|
    t.integer  "activity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "successful"
    t.text     "comments"
    t.boolean  "completed"
  end

  add_index "pomodoros", ["activity_id"], :name => "index_pomodoros_on_activity_id"
  add_index "pomodoros", ["completed"], :name => "index_pomodoros_on_completed"
  add_index "pomodoros", ["successful"], :name => "index_pomodoros_on_successful"

  create_table "todotodays", :force => true do |t|
    t.text     "comments"
    t.integer  "activity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "today"
  end

  add_index "todotodays", ["activity_id", "today"], :name => "index_todotodays_on_activity_id_and_today", :unique => true
  add_index "todotodays", ["activity_id"], :name => "index_todotodays_on_activity_id"
  add_index "todotodays", ["today"], :name => "index_todotodays_on_today"

end
