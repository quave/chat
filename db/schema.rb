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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140409114158) do

  create_table "characters", force: true do |t|
    t.string   "name",                   null: false
    t.integer  "user_id",                null: false
    t.integer  "game_id",                null: false
    t.text     "desc"
    t.integer  "color",      default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "characters", ["game_id"], name: "index_characters_on_game_id"
  add_index "characters", ["user_id"], name: "index_characters_on_user_id"

  create_table "characters_rooms", id: false, force: true do |t|
    t.integer "room_id"
    t.integer "character_id"
  end

  add_index "characters_rooms", ["room_id", "character_id"], name: "index_characters_rooms_on_room_id_and_character_id"

  create_table "games", force: true do |t|
    t.string   "name",                                null: false
    t.text     "desc"
    t.integer  "status",              default: 1,     null: false
    t.integer  "creator_id",                          null: false
    t.integer  "need_chars",          default: 2,     null: false
    t.string   "tags",                default: "",    null: false
    t.boolean  "deny_empty_requests", default: false, null: false
    t.boolean  "private",             default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", force: true do |t|
    t.text     "body",        null: false
    t.integer  "sender_id",   null: false
    t.integer  "receiver_id"
    t.integer  "room_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["receiver_id"], name: "index_messages_on_receiver_id"
  add_index "messages", ["room_id"], name: "index_messages_on_room_id"
  add_index "messages", ["sender_id"], name: "index_messages_on_sender_id"

  create_table "rooms", force: true do |t|
    t.string   "name"
    t.integer  "game_id"
    t.integer  "order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rooms", ["game_id"], name: "index_rooms_on_game_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
