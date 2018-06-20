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

ActiveRecord::Schema.define(version: 20180620102945) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authorizations", force: :cascade do |t|
    t.bigint "user_id"
    t.string "provider"
    t.string "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider", "uid"], name: "index_authorizations_on_provider_and_uid"
    t.index ["user_id"], name: "index_authorizations_on_user_id"
  end

  create_table "friendships", force: :cascade do |t|
    t.bigint "first_friend_id"
    t.bigint "second_friend_id"
    t.index ["first_friend_id"], name: "index_friendships_on_first_friend_id"
    t.index ["second_friend_id"], name: "index_friendships_on_second_friend_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "body"
    t.bigint "author_id"
    t.bigint "recipient_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id", "recipient_id"], name: "index_messages_on_author_id_and_recipient_id"
    t.index ["author_id"], name: "index_messages_on_author_id"
    t.index ["recipient_id"], name: "index_messages_on_recipient_id"
  end

  create_table "tweets", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "author_id"
    t.index ["author_id"], name: "index_tweets_on_author_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "second_name"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "authorizations", "users"
  add_foreign_key "friendships", "users", column: "first_friend_id"
  add_foreign_key "friendships", "users", column: "second_friend_id"
  add_foreign_key "messages", "users", column: "author_id"
  add_foreign_key "messages", "users", column: "recipient_id"
  add_foreign_key "tweets", "users", column: "author_id"
end
