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

ActiveRecord::Schema.define(version: 20160609082358) do

  create_table "clients", force: :cascade do |t|
    t.string   "name"
    t.string   "password"
    t.string   "description"
    t.boolean  "active"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "gram_accounts", force: :cascade do |t|
    t.string   "uuid"
    t.string   "hruid"
    t.string   "id_soce"
    t.boolean  "enabled"
    t.string   "password"
    t.string   "lastname"
    t.string   "firstname"
    t.string   "birthname"
    t.string   "birth_firstname"
    t.string   "email"
    t.string   "gapps_email"
    t.string   "birthdate"
    t.string   "deathdate"
    t.string   "gender"
    t.boolean  "is_gadz"
    t.boolean  "is_student"
    t.string   "school_id"
    t.boolean  "is_alumni"
    t.string   "date_entree_ecole"
    t.string   "date_sortie_ecole"
    t.string   "ecole_entree"
    t.string   "buque_texte"
    t.string   "buque_zaloeil"
    t.string   "gadz_fams"
    t.string   "gadz_fams_zaloeil"
    t.string   "gadz_proms_principale"
    t.string   "gadz_proms_secondaire"
    t.string   "avatar_url"
    t.string   "description"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "gram_accounts_groups", force: :cascade do |t|
    t.integer  "account_id"
    t.integer  "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "gram_accounts_roles", force: :cascade do |t|
    t.integer  "account_id"
    t.integer  "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "gram_groups", force: :cascade do |t|
    t.string   "guid"
    t.string   "name"
    t.string   "short_name"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "gram_roles", force: :cascade do |t|
    t.string   "application"
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

end
