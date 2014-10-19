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

ActiveRecord::Schema.define(version: 20141017100912) do

  create_table "spree_spike_checkouts", force: true do |t|
    t.string   "token"
    t.string   "transaction_id"
    t.datetime "created_at"
    t.string   "state"
    t.text     "spike_param"
    t.integer  "payment_method_id"
    t.integer  "order_id"
    t.integer  "user_id"
    t.datetime "updated_at"
  end

  add_index "spree_spike_checkouts", ["order_id"], name: "index_spree_spike_checkouts_on_order_id", using: :btree
  add_index "spree_spike_checkouts", ["payment_method_id"], name: "index_spree_spike_checkouts_on_payment_method_id", using: :btree
  add_index "spree_spike_checkouts", ["user_id"], name: "index_spree_spike_checkouts_on_user_id", using: :btree

end
