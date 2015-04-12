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

ActiveRecord::Schema.define(version: 20150412135751) do

  create_table "brand_trucks", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "cities", force: true do |t|
    t.string   "name"
    t.integer  "state_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "states", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
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
  end

  create_table "type_trucks", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
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
