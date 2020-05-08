class ContentController < ApplicationController
  include ContentHelper

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

  private

  def get_object(item, type, puntajes)
    o = item.attributes
    o["type"] = type
    o["imagenes"] = []
    o["thumbnail"] = generate_thumb(item)
    o["puntaje"] = nil
    o["puntajes"] = puntajes
    o["comentarios"] = item.comentarios unless type == "pois"
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
end
