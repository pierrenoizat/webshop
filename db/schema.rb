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

ActiveRecord::Schema.define(:version => 20140912143106) do

  create_table "carts", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoices", :force => true do |t|
    t.string   "name"
    t.decimal  "montant"
    t.string   "adresse"
    t.string   "email"
    t.string   "contenu"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
    t.integer  "order_id"
    t.string   "btc_address"
    t.string   "pay_type"
    t.decimal  "amount_paid"
    t.string   "country"
    t.string   "city"
    t.string   "zip_code"
    t.string   "qrcode_string"
  end

  create_table "line_items", :force => true do |t|
    t.integer  "product_id"
    t.integer  "cart_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quantity",   :default => 1
    t.integer  "order_id"
    t.decimal  "price"
  end

  create_table "orders", :force => true do |t|
    t.string   "name"
    t.text     "address"
    t.string   "email"
    t.string   "pay_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "total"
    t.string   "content"
    t.string   "btc_address"
    t.decimal  "conv_rate"
    t.decimal  "conv_total"
    t.string   "country"
    t.string   "city"
    t.string   "zip_code"
    t.string   "invoice_code"
    t.string   "qrcode_string"
  end

  create_table "products", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "image_url"
    t.decimal  "price",          :precision => 8, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_category"
    t.integer  "stock"
    t.string   "photo_url"
    t.string   "locale"
    t.string   "currency"
  end

  create_table "rates", :force => true do |t|
    t.decimal  "valeur"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "amount"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "hashed_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
