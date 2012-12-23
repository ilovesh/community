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

ActiveRecord::Schema.define(:version => 20121223082609) do

  create_table "comments", :force => true do |t|
    t.integer  "commentable_id",   :default => 0
    t.string   "commentable_type", :default => ""
    t.text     "body",             :default => ""
    t.integer  "user_id",          :default => 0,  :null => false
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "courses", :force => true do |t|
    t.string   "name"
    t.integer  "provider_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "code"
    t.string   "image_link"
    t.text     "description"
    t.string   "subtitle"
    t.string   "instructor"
    t.text     "prerequisites"
    t.string   "url"
    t.datetime "start_date"
    t.datetime "final_date"
    t.integer  "duration"
  end

  add_index "courses", ["name"], :name => "index_courses_on_name"

  create_table "discussions", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "enrollments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "course_id"
    t.integer  "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "listings", :force => true do |t|
    t.integer  "list_id"
    t.integer  "course_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.text     "description"
  end

  create_table "lists", :force => true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.text     "description"
  end

  create_table "notes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "course_id"
    t.string   "title"
    t.text     "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "providers", :force => true do |t|
    t.string   "name"
    t.string   "website"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "providers", ["name"], :name => "index_providers_on_name"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "teachings", :force => true do |t|
    t.integer  "university_id"
    t.integer  "course_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "universities", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "universities", ["name"], :name => "index_universities_on_name"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.string   "username"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "remember_token"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

  create_table "votes", :force => true do |t|
    t.boolean  "vote",          :default => false, :null => false
    t.integer  "voteable_id",                      :null => false
    t.string   "voteable_type",                    :null => false
    t.integer  "user_id"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "votes", ["user_id", "voteable_id", "voteable_type"], :name => "fk_one_vote_per_user_per_entity", :unique => true
  add_index "votes", ["voteable_id", "voteable_type"], :name => "index_votes_on_voteable_id_and_voteable_type"

end
