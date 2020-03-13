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
      out << content.as_json(except: %i[puntajes puntaje]).merge(type: item["type"], imagenes: imgs)
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
    o["imagenes"] = item.imagenes.attached? ? [rails_blob_path(item.imagenes.attachments.first)] : []
    o["puntaje"] = nil
    o["puntajes"] = puntajes
    o["comentarios"] = item.comentarios unless type == "pois"
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
      .order(created_at: :desc).first(5 + params[:offset].to_i).map do |p|
      get_object(
        p,
        type,
        p.my_puntajes
      )
    end
  end

  def build_feed(_params)
    [
      build_objects("publicaciones"),
      build_objects("recetas"),
      build_objects("pois")
    ].flatten
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
end
