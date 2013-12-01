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

ActiveRecord::Schema.define(version: 20131201070629) do

  create_table "bargains", force: true do |t|
    t.integer  "product_id"
    t.string   "price"
    t.string   "discount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "history_low"
  end

  create_table "prices", force: true do |t|
    t.string   "product_id"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "prices", ["product_id"], name: "index_prices_on_product_id", using: :btree

  create_table "product_lists", force: true do |t|
    t.string   "type"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url_key"
  end

  add_index "product_lists", ["url"], name: "index_product_lists_on_url", using: :btree

  create_table "product_roots", force: true do |t|
    t.string   "type"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_roots", ["url"], name: "index_product_roots_on_url", using: :btree

  create_table "products", force: true do |t|
    t.string   "type"
    t.string   "name"
    t.string   "info"
    t.string   "category"
    t.string   "url"
    t.string   "url_key"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "price_key"
    t.integer  "low_price"
  end

  create_table "sites", force: true do |t|
    t.string   "name"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
