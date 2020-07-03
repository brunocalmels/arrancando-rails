# rubocop: disable Metrics/ClassLength

class ContentController < ApplicationController
  include ContentHelper
  include NotificacionesHelper

  # GET /content?data=[{1: publicaciones}, {2: recetas}, {3: pois},].json
  def saved
    out = []
    items = JSON[params[:data]]
    items.each do |item|
      case item["type"]
      when "publicaciones"
        content = Publicacion.find(item["id"])
      when "recetas"
        content = Receta.find(item["id"])
      when "pois"
        content = Poi.find(item["id"])
      end
      next if content.nil?

      imgs = content_images(content)
      out << content.as_json(except: %i[puntajes puntaje]).merge(
        type: item["type"],
        imagenes: imgs,
        thumbnail: generate_thumb(content),
        user: get_user(content)
      )
    end
    render json: out, status: :ok
  end

  def index
    render json: build_feed(params), status: :ok
  end

  def shared_this
    id = params['id']
    tipo = params['type']
    case tipo
    when "publicaciones"
      content = Publicacion.find(id)
    when "recetas"
      content = Receta.find(id)
    when "pois"
      content = Poi.find(id)
    end

    if !content.nil?
      compartio_contenido(content, tipo)
      render json: nil, status: :ok
    else
      render json: nil, status: :unprocessable_entity
    end
  end

  # rubocop: disable Metrics/AbcSize
  def count
    unless params['user_id']
      render json: nil, status: :unprocessable_entity && return
    end

    render json: {
      "publicaciones": Publicacion.where(user_id: params['user_id'].to_i).count,
      "recetas": Receta.where(user_id: params['user_id'].to_i).count,
      "pois": Poi.where(user_id: params['user_id'].to_i).count,
      # "wiki": Wiki.where(user_id: params['user_id'].to_i).count
      "master": get_master(params['user_id'].to_i),
      "siguiendo": get_siguiendo(params['user_id'].to_i)
    }, status: :ok
  end
  # rubocop: enable Metrics/AbcSize

  private

  def get_object(item, type, puntajes)
    o = item.attributes
    o["type"] = type
    o["imagenes"] = []
    o["thumbnail"] = generate_thumb(item)
    o["puntaje"] = nil
    o["puntajes"] = puntajes
    o["comentarios"] = item.comentarios.as_json(except: %i[puntajes puntaje])
    o["user"] = get_user(item)
    o
  end

  def build_objects(type)
    ac_record = Publicacion
    case type
    when "publicaciones"
      ac_record = Publicacion
    when "recetas"
      ac_record = Receta
    when "pois"
      ac_record = Poi
    end
    # .where(user: current_user)
    ac_record
      .order(updated_at: :desc).page(params[:page]).per(10).map do |p|
      get_object(
        p,
        type,
        p.my_puntajes
      )
    end
  end

  def build_feed(pars)
    to_show = []
    if pars[:contenidos_home].nil?
      to_show = [
        build_objects("publicaciones"),
        build_objects("recetas"),
        build_objects("pois")
      ]
    else
      contenidos_home = JSON.parse(pars[:contenidos_home])
      contenidos_home.each do |ch|
        to_show << build_objects(ch)
      end
    end

    to_show.flatten.sort_by { |c| c["created_at"] }.reverse
  end

  def content_images(content)
    if content.imagenes.attached?
      content.imagenes.attachments.map do |img|
        asset_url_for(img, device: "web")
      end
    else
      []
    end
  end

  def get_user(content)
    has_avatar = content.user.avatar.attached?
    content.user.as_json.merge(
      "avatar" => has_avatar ? rails_blob_path(content.user.avatar) : "/images/unknown.png"
    )
  end

  def get_master(user_id)
    count = 0
    selected = ''
    Receta.where(user_id: user_id)
          .joins(:categoria_receta)
          .select(:nombre)
          .group(:nombre)
          .count
          .map do |k, v|
      if v > count
        count = v
        selected = k
      end
    end
    selected.downcase
  end

  def get_siguiendo(user_id)
    seguimiento = Seguimiento.where(
      seguidor_id: current_user.id,
      seguido_id: user_id
    ).first
    seguimiento.nil? ? nil : seguimiento.id
  end
end

# rubocop: enable Metrics/ClassLength
