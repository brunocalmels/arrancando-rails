# rubocop: disable Metrics/ClassLength
# rubocop: disable Metrics/AbcSize
# rubocop: disable Metrics/CyclomaticComplexity
# rubocop: disable Metrics/PerceivedComplexity

class ContentController < ApplicationController
  include ContentHelper
  include NotificacionesHelper

  caches_action :index,
                expires_in: DEFAULT_INDEX_ACTION_CACHE_DURATION,
                cache_path: -> { request.fullpath + "/user_id=" + current_user.id.to_s },
                if: -> { request.format.json? }

  # TODO: Fix this. Lots of room for improvement (rewrite as ActiveRecord queries)
  # PERFORMANCE
  # GET /content?data=[{1: publicaciones}, {2: recetas}, {3: pois},].json
  def saved
    out = []
    items = JSON[params[:data]]
    items.each do |item|
      case item["type"]
      when "publicaciones"
        content = Publicacion.with_attached_imagenes.find(item["id"])
      when "recetas"
        content = Receta.with_attached_imagenes.find(item["id"])
      when "pois"
        content = Poi.with_attached_imagenes.find(item["id"])
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
    content = build_feed(params)
    render json: content, status: :ok
  end

  def shared_this
    id = params["id"]
    tipo = params["type"]
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

  def count
    unless params["user_id"]
      render json: nil, status: :unprocessable_entity && return
    end

    render json: {
      "publicaciones": Publicacion.where(user_id: params["user_id"].to_i).count,
      "recetas": Receta.where(user_id: params["user_id"].to_i).count,
      "pois": Poi.where(user_id: params["user_id"].to_i).count,
      # "wiki": Wiki.where(user_id: params['user_id'].to_i).count
      "master": get_master(params["user_id"].to_i),
      "siguiendo": siguiendo?(params["user_id"].to_i),
      "seguidos": get_seguidos(params["user_id"].to_i),
      "seguidores": get_seguidores(params["user_id"].to_i),
      "likes": get_likes(params["user_id"].to_i),
      "experiencia": User.find(params["user_id"].to_i).puntaje
    }, status: :ok
  end

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
    o["seguido"] = seguido?(item.user_id)
    o["color"] = item.likes_color
    o
  end

  def build_objects(type, only_followed=nil)
    ac_record = Publicacion
    case type
    when "publicaciones"
      ac_record = Publicacion
    when "recetas"
      ac_record = Receta
    when "pois"
      ac_record = Poi
    end
    unless only_followed.nil?
      ac_record = ac_record.where(user_id: only_followed)
    end
    ac_record
      .where("puntajes -> '?' is null", current_user.id) # Not rated by user
      .order("RANDOM()") # .order(updated_at: :desc)
      .page(params[:page])
      .per(10)
      .uniq(&:user_id)
      .map do |p|
      get_object(
        p,
        type,
        p.my_puntajes
      )
    end
  end

  def build_feed(pars)
    to_show = []
    if pars[:contenidos_home].nil? || JSON.parse(pars[:contenidos_home]) == ["followed"]
      only_followed = nil
      if !pars[:contenidos_home].nil? && JSON.parse(pars[:contenidos_home]) == ["followed"]
        only_followed = current_user.seguimientos.pluck(:seguido_id)
      end
      to_show = [
        build_objects("publicaciones", only_followed),
        build_objects("recetas", only_followed)
        # build_objects("pois", only_followed) # Too many Pois, not currently showing them.
      ]
    else
      contenidos_home = JSON.parse(pars[:contenidos_home])
      only_followed = nil
      if contenidos_home.include?("followed")
        only_followed = current_user.seguimientos.pluck(:seguido_id)
      end
      contenidos_home.each do |ch|
        # next if ch == 'pois' # In case we dont want to show Pois

        to_show << build_objects(ch, only_followed) if ch != "followed"
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
    selected = ""
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

  def siguiendo?(user_id)
    seguimiento = Seguimiento.where(
      seguidor_id: current_user.id,
      seguido_id: user_id
    ).first
    seguimiento.nil? ? nil : seguimiento.id
  end

  def seguido?(user_id)
    seguimiento = Seguimiento.where(
      seguidor_id: current_user.id,
      seguido_id: user_id
    ).first
    seguimiento.nil? ? nil : seguimiento.id
  end

  def get_seguidos(user_id)
    Seguimiento.where(
      seguidor_id: user_id
    ).count
  end

  def get_seguidores(user_id)
    Seguimiento.where(
      seguido_id: user_id
    ).count
  end

  def get_likes(user_id)
    Publicacion.likes(user_id) + Receta.likes(user_id) + Poi.likes(user_id)
  end
end

# rubocop: enable Metrics/PerceivedComplexity
# rubocop: enable Metrics/CyclomaticComplexity
# rubocop: enable Metrics/AbcSize
# rubocop: enable Metrics/ClassLength
