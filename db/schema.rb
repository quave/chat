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

ActiveRecord::Schema.define(version: 20140929140450) do

  create_table "characters", force: true do |t|
    t.string   "name",                        null: false
    t.integer  "user_id",                     null: false
    t.integer  "game_id",                     null: false
    t.boolean  "master",      default: false, null: false
    t.text     "major_attr",  default: "",    null: false
    t.text     "minor_attr",  default: "",    null: false
    t.text     "description", default: "",    null: false
    t.text     "inventory",   default: "",    null: false
    t.integer  "status",      default: 0,     null: false
    t.integer  "color",       default: 0,     null: false
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
    t.string   "name",                    null: false
    t.text     "desc"
    t.integer  "status",     default: 1,  null: false
    t.integer  "creator_id",              null: false
    t.integer  "need_chars", default: 2,  null: false
    t.string   "tags",       default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", force: true do |t|
    t.text     "body",       null: false
    t.integer  "sender_id",  null: false
    t.integer  "room_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["room_id"], name: "index_messages_on_room_id"
  add_index "messages", ["sender_id"], name: "index_messages_on_sender_id"

  create_table "rooms", force: true do |t|
    t.string   "name",                   null: false
    t.integer  "game_id",                null: false
    t.integer  "order",      default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rooms", ["game_id"], name: "index_rooms_on_game_id"

  create_table "rooms_characters", id: false, force: true do |t|
    t.integer "room_id"
    t.integer "character_id"
  end

  add_index "rooms_characters", ["room_id", "character_id"], name: "index_rooms_characters_on_room_id_and_character_id", unique: true

  create_table "rooms_users_visits", primary_key: "[:room_id, :user_id]", force: true do |t|
    t.integer  "room_id"
    t.integer  "user_id"
    t.datetime "last_visited", null: false
  end

  create_table "users", force: true do |t|
    t.string   "name",                                    null: false
    t.boolean  "send_unread",            default: true,   null: false
    t.boolean  "show_email",             default: false,  null: false
    t.text     "description",            default: "",     null: false
    t.string   "email",                  default: "",     null: false
    t.string   "encrypted_password",     default: "",     null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["name"], name: "index_users_on_name", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
