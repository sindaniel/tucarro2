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

ActiveRecord::Schema.define(version: 20150413141641) do

  create_table "brand_extras", force: true do |t|
    t.string   "name"
    t.string   "link_rewrite"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "brand_trucks", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "link_rewrite"
  end

  create_table "cities", force: true do |t|
    t.string   "name"
    t.integer  "state_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "link_rewrite"
  end

  create_table "extras", force: true do |t|
    t.string   "name"
    t.float    "price",                 limit: 24
    t.string   "address"
    t.integer  "state_id"
    t.integer  "city_id"
    t.string   "phone"
    t.string   "horario"
    t.text     "description"
    t.integer  "type_extra_id"
    t.integer  "brand_extra_id"
    t.string   "link_rewrite"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "picture1_file_name"
    t.string   "picture1_content_type"
    t.integer  "picture1_file_size"
    t.datetime "picture1_updated_at"
    t.string   "picture2_file_name"
    t.string   "picture2_content_type"
    t.integer  "picture2_file_size"
    t.datetime "picture2_updated_at"
    t.string   "picture3_file_name"
    t.string   "picture3_content_type"
    t.integer  "picture3_file_size"
    t.datetime "picture3_updated_at"
    t.string   "picture4_file_name"
    t.string   "picture4_content_type"
    t.integer  "picture4_file_size"
    t.datetime "picture4_updated_at"
    t.string   "picture5_file_name"
    t.string   "picture5_content_type"
    t.integer  "picture5_file_size"
    t.datetime "picture5_updated_at"
  end

  create_table "states", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "link_rewrite"
  end

  create_table "trucks", force: true do |t|
    t.string   "nombre"
    t.string   "modelo"
    t.string   "ubicacion"
    t.string   "kilometraje"
    t.integer  "estado"
    t.string   "placa"
    t.string   "ubicacionplaca"
    t.string   "color"
    t.string   "tipocombustible"
    t.string   "marcamotor"
    t.string   "marcacaja"
    t.string   "marcatransmision"
    t.boolean  "quintarueda"
    t.string   "tipocupo"
    t.string   "empresaafiliada"
    t.string   "marcacarpa"
    t.string   "capacidadcarga"
    t.string   "capacidadpasajeros"
    t.string   "cilindrajecc"
    t.string   "numeroejes"
    t.boolean  "trailer"
    t.boolean  "negociable"
    t.string   "estadollantas"
    t.boolean  "vigia"
    t.integer  "tipodecaja"
    t.boolean  "motorreparado"
    t.boolean  "cajareparada"
    t.boolean  "transmisionreparada"
    t.boolean  "frenosabs"
    t.boolean  "cupo"
    t.boolean  "sillareclinable"
    t.boolean  "bano"
    t.boolean  "descansapies"
    t.boolean  "tv"
    t.boolean  "pantallaindividual"
    t.boolean  "wifi"
    t.boolean  "audio"
    t.boolean  "unicodueno"
    t.integer  "brand_truck_id"
    t.integer  "type_truck_id"
    t.text     "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "state_id"
    t.integer  "city_id"
    t.float    "price",                 limit: 24
    t.string   "link_rewrite"
    t.string   "picture1_file_name"
    t.string   "picture1_content_type"
    t.integer  "picture1_file_size"
    t.datetime "picture1_updated_at"
    t.string   "picture2_file_name"
    t.string   "picture2_content_type"
    t.integer  "picture2_file_size"
    t.datetime "picture2_updated_at"
    t.string   "picture3_file_name"
    t.string   "picture3_content_type"
    t.integer  "picture3_file_size"
    t.datetime "picture3_updated_at"
    t.string   "picture4_file_name"
    t.string   "picture4_content_type"
    t.integer  "picture4_file_size"
    t.datetime "picture4_updated_at"
    t.string   "picture5_file_name"
    t.string   "picture5_content_type"
    t.integer  "picture5_file_size"
    t.datetime "picture5_updated_at"
    t.text     "descripccion"
  end

  create_table "type_extras", force: true do |t|
    t.string   "name"
    t.string   "link_rewrite"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "type_trucks", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "link_rewrite"
  end

  create_table "users", force: true do |t|
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

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
