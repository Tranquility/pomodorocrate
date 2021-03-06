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

ActiveRecord::Schema.define(:version => 20120905192840) do

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "activities", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "estimated_pomodoros"
    t.date     "deadline"
    t.boolean  "completed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "start_at"
    t.datetime "end_at"
    t.boolean  "event_type",            :default => false
    t.boolean  "unplanned",             :default => false
    t.string   "cached_tag_list"
    t.string   "priority",              :default => "none"
    t.string   "created_at_local_time"
    t.boolean  "someday"
  end

  add_index "activities", ["completed"], :name => "index_activities_on_completed"
  add_index "activities", ["created_at_local_time"], :name => "index_activities_on_created_at_local_time"
  add_index "activities", ["deadline"], :name => "index_activities_on_deadline"
  add_index "activities", ["end_at"], :name => "index_activities_on_end_at"
  add_index "activities", ["event_type"], :name => "index_activities_on_event_type"
  add_index "activities", ["priority"], :name => "index_activities_on_priority"
  add_index "activities", ["project_id"], :name => "index_activities_on_project_id"
  add_index "activities", ["someday"], :name => "index_activities_on_someday"
  add_index "activities", ["start_at"], :name => "index_activities_on_start_at"
  add_index "activities", ["unplanned"], :name => "index_activities_on_unplanned"
  add_index "activities", ["user_id"], :name => "index_activities_on_user_id"

  create_table "breaks", :force => true do |t|
    t.boolean  "completed"
    t.integer  "duration",   :default => 5
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "breaks", ["completed"], :name => "index_breaks_on_completed"
  add_index "breaks", ["user_id"], :name => "index_breaks_on_user_id"

  create_table "comments", :force => true do |t|
    t.text     "content"
    t.integer  "activity_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["activity_id"], :name => "index_comments_on_activity_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "contact_requests", :force => true do |t|
    t.text     "content"
    t.boolean  "bug"
    t.boolean  "feature_request"
    t.boolean  "suggestion"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "debug_info"
  end

  create_table "contacts", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dummies", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "interruptions", :force => true do |t|
    t.string   "kind"
    t.integer  "pomodoro_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "created_at_local_time"
  end

  add_index "interruptions", ["created_at_local_time"], :name => "index_interruptions_on_created_at_local_time"
  add_index "interruptions", ["user_id"], :name => "index_interruptions_on_user_id"

  create_table "pomodoros", :force => true do |t|
    t.integer  "activity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "successful"
    t.text     "comments"
    t.boolean  "completed"
    t.integer  "user_id"
    t.integer  "duration",              :default => 25
    t.string   "created_at_local_time"
  end

  add_index "pomodoros", ["activity_id"], :name => "index_pomodoros_on_activity_id"
  add_index "pomodoros", ["completed"], :name => "index_pomodoros_on_completed"
  add_index "pomodoros", ["created_at"], :name => "index_pomodoros_on_created_at"
  add_index "pomodoros", ["created_at_local_time"], :name => "index_pomodoros_on_created_at_local_time"
  add_index "pomodoros", ["successful"], :name => "index_pomodoros_on_successful"
  add_index "pomodoros", ["user_id"], :name => "index_pomodoros_on_user_id"

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.boolean  "completed",                :default => false
    t.string   "color",       :limit => 7
  end

  add_index "projects", ["completed"], :name => "index_projects_on_completed"
  add_index "projects", ["name"], :name => "index_projects_on_name"
  add_index "projects", ["user_id"], :name => "index_projects_on_user_id"

  create_table "settings", :force => true do |t|
    t.boolean  "tooltips",                   :default => false
    t.boolean  "ring_sound",                 :default => true
    t.boolean  "tick_tack_sound",            :default => true
    t.boolean  "voice_notifications",        :default => true
    t.integer  "ring_sound_volume",          :default => 10
    t.integer  "tick_tack_sound_volume",     :default => 5
    t.integer  "voice_notifications_volume", :default => 10
    t.boolean  "email_notifications",        :default => true
    t.integer  "pomodoro_length",            :default => 25
    t.integer  "short_break_length",         :default => 5
    t.integer  "long_break_length",          :default => 30
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["user_id"], :name => "index_settings_on_user_id"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
    t.integer  "tagger_id"
    t.integer  "tagger_type"
    t.string   "context",       :limit => 128
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "todotodays", :force => true do |t|
    t.text     "comments"
    t.integer  "activity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "today"
    t.integer  "user_id"
    t.integer  "position"
  end

  add_index "todotodays", ["activity_id", "today"], :name => "index_todotodays_on_activity_id_and_today", :unique => true
  add_index "todotodays", ["activity_id"], :name => "index_todotodays_on_activity_id"
  add_index "todotodays", ["position"], :name => "index_todotodays_on_position"
  add_index "todotodays", ["today"], :name => "index_todotodays_on_today"
  add_index "todotodays", ["user_id"], :name => "index_todotodays_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password"
    t.string   "salt"
    t.boolean  "admin",               :default => false
    t.string   "confirmation_hash"
    t.string   "reset_password_hash"
    t.string   "time_zone"
    t.boolean  "email_notifications", :default => false
    t.boolean  "voice_notifications", :default => false
    t.integer  "pomodoro_length",     :default => 25
    t.integer  "short_break_length",  :default => 5
    t.integer  "long_break_length",   :default => 25
    t.integer  "account_id"
    t.boolean  "tick_tack_sound",     :default => false
    t.string   "api_key"
  end

  add_index "users", ["api_key"], :name => "index_users_on_api_key", :unique => true
  add_index "users", ["confirmation_hash"], :name => "index_users_on_confirmation_hash"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_hash"], :name => "index_users_on_reset_password_hash"

end
