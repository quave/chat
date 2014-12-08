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

ActiveRecord::Schema.define(version: 20141205160489) do

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

  create_table "forem_categories", force: true do |t|
    t.string   "name",                   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.integer  "position",   default: 0
  end

  add_index "forem_categories", ["slug"], name: "index_forem_categories_on_slug", unique: true

  create_table "forem_forums", force: true do |t|
    t.string  "name"
    t.text    "description"
    t.integer "category_id"
    t.integer "views_count", default: 0
    t.string  "slug"
    t.integer "position",    default: 0
  end

  add_index "forem_forums", ["slug"], name: "index_forem_forums_on_slug", unique: true

  create_table "forem_groups", force: true do |t|
    t.string "name"
  end

  add_index "forem_groups", ["name"], name: "index_forem_groups_on_name"

  create_table "forem_memberships", force: true do |t|
    t.integer "group_id"
    t.integer "member_id"
  end

  add_index "forem_memberships", ["group_id"], name: "index_forem_memberships_on_group_id"

  create_table "forem_moderator_groups", force: true do |t|
    t.integer "forum_id"
    t.integer "group_id"
  end

  add_index "forem_moderator_groups", ["forum_id"], name: "index_forem_moderator_groups_on_forum_id"

  create_table "forem_posts", force: true do |t|
    t.integer  "topic_id"
    t.text     "text"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "reply_to_id"
    t.string   "state",       default: "pending_review"
    t.boolean  "notified",    default: false
  end

  add_index "forem_posts", ["reply_to_id"], name: "index_forem_posts_on_reply_to_id"
  add_index "forem_posts", ["state"], name: "index_forem_posts_on_state"
  add_index "forem_posts", ["topic_id"], name: "index_forem_posts_on_topic_id"
  add_index "forem_posts", ["user_id"], name: "index_forem_posts_on_user_id"

  create_table "forem_subscriptions", force: true do |t|
    t.integer "subscriber_id"
    t.integer "topic_id"
  end

  create_table "forem_topics", force: true do |t|
    t.integer  "forum_id"
    t.integer  "user_id"
    t.string   "subject"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "locked",       default: false,            null: false
    t.boolean  "pinned",       default: false
    t.boolean  "hidden",       default: false
    t.datetime "last_post_at"
    t.string   "state",        default: "pending_review"
    t.integer  "views_count",  default: 0
    t.string   "slug"
  end

  add_index "forem_topics", ["forum_id"], name: "index_forem_topics_on_forum_id"
  add_index "forem_topics", ["slug"], name: "index_forem_topics_on_slug", unique: true
  add_index "forem_topics", ["state"], name: "index_forem_topics_on_state"
  add_index "forem_topics", ["user_id"], name: "index_forem_topics_on_user_id"

  create_table "forem_views", force: true do |t|
    t.integer  "user_id"
    t.integer  "viewable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "count",             default: 0
    t.string   "viewable_type"
    t.datetime "current_viewed_at"
    t.datetime "past_viewed_at"
  end

  add_index "forem_views", ["updated_at"], name: "index_forem_views_on_updated_at"
  add_index "forem_views", ["user_id"], name: "index_forem_views_on_user_id"
  add_index "forem_views", ["viewable_id"], name: "index_forem_views_on_viewable_id"

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
    t.string   "name",                                              null: false
    t.boolean  "send_unread",            default: true,             null: false
    t.boolean  "show_email",             default: false,            null: false
    t.text     "description",            default: "",               null: false
    t.string   "email",                  default: "",               null: false
    t.string   "encrypted_password",     default: "",               null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,                null: false
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
    t.boolean  "forem_admin",            default: false
    t.string   "forem_state",            default: "pending_review"
    t.boolean  "forem_auto_subscribe",   default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["name"], name: "index_users_on_name", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
