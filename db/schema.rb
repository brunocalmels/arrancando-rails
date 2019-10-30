# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_10_30_154815) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "categoria_pois", force: :cascade do |t|
    t.string "nombre", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "categoria_recetas", force: :cascade do |t|
    t.string "nombre", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "ciudades", force: :cascade do |t|
    t.string "nombre", null: false
    t.bigint "provincia_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["provincia_id"], name: "index_ciudades_on_provincia_id"
  end

  create_table "pois", force: :cascade do |t|
    t.string "titulo", null: false
    t.text "cuerpo"
    t.float "lat", null: false
    t.float "long", null: false
    t.jsonb "puntaje"
    t.bigint "categoria_poi_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.geography "geo_point", limit: {:srid=>4326, :type=>"st_point", :geographic=>true}
    t.string "direccion"
    t.index ["categoria_poi_id"], name: "index_pois_on_categoria_poi_id"
    t.index ["geo_point"], name: "index_pois_on_geo_point", using: :gist
    t.index ["titulo"], name: "index_pois_on_titulo"
  end

  create_table "provincias", force: :cascade do |t|
    t.string "nombre", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "publicaciones", force: :cascade do |t|
    t.string "titulo", null: false
    t.text "cuerpo", null: false
    t.jsonb "puntajes"
    t.bigint "ciudad_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ciudad_id"], name: "index_publicaciones_on_ciudad_id"
    t.index ["titulo"], name: "index_publicaciones_on_titulo"
  end

  create_table "recetas", force: :cascade do |t|
    t.string "titulo", null: false
    t.text "cuerpo"
    t.jsonb "puntaje"
    t.bigint "categoria_receta_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["categoria_receta_id"], name: "index_recetas_on_categoria_receta_id"
    t.index ["titulo"], name: "index_recetas_on_titulo"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest"
    t.string "nombre"
    t.string "apellido"
    t.string "username"
    t.bigint "telefono"
    t.integer "rol"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "activo"
    t.index ["email"], name: "index_users_on_email"
    t.index ["username"], name: "index_users_on_username"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "ciudades", "provincias"
  add_foreign_key "pois", "categoria_pois"
  add_foreign_key "publicaciones", "ciudades"
  add_foreign_key "recetas", "categoria_recetas"
end
