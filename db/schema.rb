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

ActiveRecord::Schema.define(version: 20160705065458) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clients", force: :cascade do |t|
    t.string   "name"
    t.string   "password"
    t.string   "description"
    t.boolean  "active"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "email",                             default: ""
    t.string   "encrypted_password",                default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "authentication_token",   limit: 30
  end

  add_index "clients", ["authentication_token"], name: "index_clients_on_authentication_token", unique: true, using: :btree
  add_index "clients", ["name"], name: "index_clients_on_name", unique: true, using: :btree
  add_index "clients", ["reset_password_token"], name: "index_clients_on_reset_password_token", unique: true, using: :btree

  create_table "clients_roles", id: false, force: :cascade do |t|
    t.integer "client_id"
    t.integer "role_id"
  end

  add_index "clients_roles", ["client_id", "role_id"], name: "index_clients_roles_on_client_id_and_role_id", using: :btree

  create_table "gram_accounts", force: :cascade do |t|
    t.uuid     "uuid"
    t.string   "hruid"
    t.integer  "id_soce",               default: "nextval('id_soce_seq'::regclass)"
    t.boolean  "enabled",               default: true
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
    t.datetime "created_at",                                                         null: false
    t.datetime "updated_at",                                                         null: false
    t.boolean  "is_soce_employee",      default: false
  end

  add_index "gram_accounts", ["hruid"], name: "index_gram_accounts_on_hruid", using: :btree
  add_index "gram_accounts", ["id_soce"], name: "index_gram_accounts_on_id_soce", using: :btree
  add_index "gram_accounts", ["uuid"], name: "index_gram_accounts_on_uuid", using: :btree

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

  create_table "gram_aliases", force: :cascade do |t|
    t.integer  "account_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "gram_groups", force: :cascade do |t|
    t.string   "uuid"
    t.string   "name"
    t.string   "short_name"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "uuid_id"
  end

  add_index "gram_groups", ["uuid_id"], name: "index_gram_groups_on_uuid_id", using: :btree

  create_table "gram_roles", force: :cascade do |t|
    t.string   "application"
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "uuid"
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

end
