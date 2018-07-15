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

ActiveRecord::Schema.define(version: 20180715205213) do

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

  create_table "cartridge_service_guides", force: :cascade do |t|
    t.string "model_name"
    t.integer "toner_life_count"
    t.string "price_for_refill"
    t.string "color"
    t.bigint "printer_service_guide_id"
    t.index ["model_name"], name: "index_cartridge_service_guides_on_model_name"
    t.index ["printer_service_guide_id"], name: "index_cartridge_service_guides_on_printer_service_guide_id"
  end

  create_table "cartridges", force: :cascade do |t|
    t.string "price_for_customer"
    t.string "additional_data"
    t.string "masters_note"
    t.bigint "cartridge_service_guide_id"
    t.index ["cartridge_service_guide_id"], name: "index_cartridges_on_cartridge_service_guide_id"
  end

  create_table "logs", force: :cascade do |t|
    t.string "body"
    t.bigint "user_id"
    t.string "registerable_type"
    t.bigint "registerable_id"
    t.index ["registerable_type", "registerable_id"], name: "index_logs_on_registerable_type_and_registerable_id"
    t.index ["user_id"], name: "index_logs_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "body"
    t.bigint "sender_id"
    t.bigint "receiver_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["receiver_id"], name: "index_messages_on_receiver_id"
    t.index ["sender_id", "receiver_id"], name: "index_messages_on_sender_id_and_receiver_id"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
  end

  create_table "orders", force: :cascade do |t|
    t.datetime "date_of_order"
    t.datetime "date_of_complete"
    t.datetime "suitable_time"
    t.string "additional_data"
    t.integer "revenue"
    t.integer "expense"
    t.integer "profit"
    t.bigint "customer_id"
    t.bigint "manager_id"
    t.bigint "master_id"
    t.index ["customer_id"], name: "index_orders_on_customer_id"
    t.index ["manager_id"], name: "index_orders_on_manager_id"
    t.index ["master_id"], name: "index_orders_on_master_id"
  end

  create_table "printer_service_guides", force: :cascade do |t|
    t.string "model_name"
    t.integer "fuser_life_count"
    t.string "sheet_size"
    t.boolean "color"
    t.string "type"
    t.index ["model_name"], name: "index_printer_service_guides_on_model_name"
  end

  create_table "printers", force: :cascade do |t|
    t.string "serial_number"
    t.integer "fuser_life_count"
    t.string "additional_data"
    t.string "masters_note"
    t.bigint "printer_service_guide_id"
    t.index ["printer_service_guide_id"], name: "index_printers_on_printer_service_guide_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "second_name"
    t.string "adress"
    t.string "company"
    t.string "telephone"
    t.string "post_in_company"
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
    t.index ["adress"], name: "index_users_on_adress"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "authorizations", "users"
  add_foreign_key "messages", "users", column: "receiver_id"
  add_foreign_key "messages", "users", column: "sender_id"
  add_foreign_key "orders", "users", column: "customer_id"
  add_foreign_key "orders", "users", column: "manager_id"
  add_foreign_key "orders", "users", column: "master_id"
end
