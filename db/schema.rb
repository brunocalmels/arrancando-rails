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

ActiveRecord::Schema.define(version: 2020_12_29_132146) do

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

  create_table "categoria_publicaciones", force: :cascade do |t|
    t.string "nombre", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "categoria_recetas", force: :cascade do |t|
    t.string "nombre", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "version", default: 1, null: false
  end

  create_table "ciudades", force: :cascade do |t|
    t.string "nombre", null: false
    t.bigint "provincia_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "populada", default: false
    t.datetime "fecha_populacion"
    t.string "version_script_populacion"
    t.string "rubros", default: [], array: true
    t.index ["provincia_id"], name: "index_ciudades_on_provincia_id"
  end

  create_table "comentario_pois", force: :cascade do |t|
    t.bigint "poi_id", null: false
    t.bigint "user_id", null: false
    t.text "mensaje", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.jsonb "puntajes", default: {}
    t.index ["poi_id"], name: "index_comentario_pois_on_poi_id"
    t.index ["user_id"], name: "index_comentario_pois_on_user_id"
  end

  create_table "comentario_publicaciones", force: :cascade do |t|
    t.bigint "publicacion_id", null: false
    t.bigint "user_id", null: false
    t.text "mensaje", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.jsonb "puntajes", default: {}
    t.index ["publicacion_id"], name: "index_comentario_publicaciones_on_publicacion_id"
    t.index ["user_id"], name: "index_comentario_publicaciones_on_user_id"
  end

  create_table "comentario_recetas", force: :cascade do |t|
    t.bigint "receta_id", null: false
    t.bigint "user_id", null: false
    t.text "mensaje", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.jsonb "puntajes", default: {}
    t.index ["receta_id"], name: "index_comentario_recetas_on_receta_id"
    t.index ["user_id"], name: "index_comentario_recetas_on_user_id"
  end

  create_table "grupo_chats", force: :cascade do |t|
    t.string "simbolo", null: false
    t.string "color", null: false
    t.string "nombre", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["nombre"], name: "index_grupo_chats_on_nombre"
  end

  create_table "ingredientes", force: :cascade do |t|
    t.string "nombre", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "mensaje_chats", force: :cascade do |t|
    t.bigint "grupo_chat_id", null: false
    t.bigint "user_id", null: false
    t.text "mensaje"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["grupo_chat_id"], name: "index_mensaje_chats_on_grupo_chat_id"
    t.index ["user_id"], name: "index_mensaje_chats_on_user_id"
  end

  create_table "notificaciones", force: :cascade do |t|
    t.string "titulo", null: false
    t.text "cuerpo"
    t.string "url"
    t.boolean "leido", default: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_notificaciones_on_user_id"
  end

  create_table "paises", force: :cascade do |t|
    t.string "nombre", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "pois", force: :cascade do |t|
    t.string "titulo", null: false
    t.text "cuerpo"
    t.float "lat", null: false
    t.float "long", null: false
    t.jsonb "puntajes", default: {}
    t.bigint "user_id", null: false
    t.bigint "categoria_poi_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "direccion"
    t.boolean "habilitado", default: true
    t.bigint "ciudad_id", default: 1, null: false
    t.bigint "whatsapp"
    t.bigint "vistas", default: 0
    t.integer "saved", default: [], array: true
    t.index ["categoria_poi_id"], name: "index_pois_on_categoria_poi_id"
    t.index ["ciudad_id"], name: "index_pois_on_ciudad_id"
    t.index ["titulo"], name: "index_pois_on_titulo"
    t.index ["user_id"], name: "index_pois_on_user_id"
  end

  create_table "provincias", force: :cascade do |t|
    t.string "nombre", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "pais_id", default: 1, null: false
    t.index ["pais_id"], name: "index_provincias_on_pais_id"
  end

  create_table "publicaciones", force: :cascade do |t|
    t.string "titulo", null: false
    t.text "cuerpo", null: false
    t.jsonb "puntajes", default: {}
    t.bigint "user_id", null: false
    t.bigint "ciudad_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "habilitado", default: true
    t.bigint "categoria_publicacion_id", default: 1, null: false
    t.bigint "vistas", default: 0
    t.integer "saved", default: [], array: true
    t.index ["categoria_publicacion_id"], name: "index_publicaciones_on_categoria_publicacion_id"
    t.index ["ciudad_id"], name: "index_publicaciones_on_ciudad_id"
    t.index ["titulo"], name: "index_publicaciones_on_titulo"
    t.index ["user_id"], name: "index_publicaciones_on_user_id"
  end

  create_table "recetas", force: :cascade do |t|
    t.string "titulo", null: false
    t.text "cuerpo"
    t.jsonb "puntajes", default: {}
    t.bigint "user_id", null: false
    t.bigint "categoria_receta_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "introduccion"
    t.text "ingredientes"
    t.text "instrucciones"
    t.boolean "habilitado", default: true
    t.integer "duracion"
    t.string "complejidad"
    t.jsonb "ingredientes_items", default: []
    t.bigint "vistas", default: 0
    t.integer "saved", default: [], array: true
    t.index ["categoria_receta_id"], name: "index_recetas_on_categoria_receta_id"
    t.index ["titulo"], name: "index_recetas_on_titulo"
    t.index ["user_id"], name: "index_recetas_on_user_id"
  end

  create_table "recetas_subcategoria_recetas", id: false, force: :cascade do |t|
    t.bigint "receta_id", null: false
    t.bigint "subcategoria_receta_id", null: false
    t.index ["receta_id", "subcategoria_receta_id"], name: "index_recetas_subcats_recetas_unique", unique: true
    t.index ["subcategoria_receta_id", "receta_id"], name: "index_subcats_recetas_unique", unique: true
  end

  create_table "reportes", force: :cascade do |t|
    t.text "contenido", default: "", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_reportes_on_user_id"
  end

  create_table "seguimientos", force: :cascade do |t|
    t.bigint "seguidor_id", null: false
    t.bigint "seguido_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["seguido_id"], name: "index_seguimientos_on_seguido_id"
    t.index ["seguidor_id"], name: "index_seguimientos_on_seguidor_id"
  end

  create_table "subcategoria_recetas", force: :cascade do |t|
    t.string "nombre", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "unidades", force: :cascade do |t|
    t.string "nombre", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest"
    t.string "nombre"
    t.string "apellido"
    t.string "username"
    t.bigint "telefono"
    t.integer "rol", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "activo"
    t.string "usernames_pasados", default: [], array: true
    t.datetime "last_seen_at"
    t.integer "rank"
    t.bigint "ciudad_id", default: 1, null: false
    t.string "app_version"
    t.string "platform"
    t.integer "rank_mensual"
    t.boolean "rankeable", default: true
    t.boolean "unlim_upload", default: false
    t.string "firebase_token"
    t.string "url_instagram"
    t.index ["ciudad_id"], name: "index_users_on_ciudad_id"
    t.index ["email"], name: "index_users_on_email"
    t.index ["username"], name: "index_users_on_username"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "ciudades", "provincias"
  add_foreign_key "comentario_pois", "pois"
  add_foreign_key "comentario_pois", "users"
  add_foreign_key "comentario_publicaciones", "publicaciones"
  add_foreign_key "comentario_publicaciones", "users"
  add_foreign_key "comentario_recetas", "recetas"
  add_foreign_key "comentario_recetas", "users"
  add_foreign_key "mensaje_chats", "grupo_chats"
  add_foreign_key "mensaje_chats", "users"
  add_foreign_key "notificaciones", "users"
  add_foreign_key "pois", "categoria_pois"
  add_foreign_key "pois", "ciudades"
  add_foreign_key "pois", "users"
  add_foreign_key "provincias", "paises"
  add_foreign_key "publicaciones", "categoria_publicaciones"
  add_foreign_key "publicaciones", "ciudades"
  add_foreign_key "publicaciones", "users"
  add_foreign_key "recetas", "categoria_recetas"
  add_foreign_key "recetas", "users"
  add_foreign_key "reportes", "users"
  add_foreign_key "seguimientos", "users", column: "seguido_id"
  add_foreign_key "seguimientos", "users", column: "seguidor_id"
  add_foreign_key "users", "ciudades"
end
