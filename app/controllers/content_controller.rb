class ContentController < ApplicationController
  include ContentHelper

  # GET /content?data=[{1: publicaciones}, {2: recetas}, {3: pois},].json
  def index
    out = []
    items = JSON[params[:data]]
    items.each do |item|
      case item['type']
      when "publicaciones"
        content = Publicacion.find(item['id'])
      when "recetas"
        content = Receta.find(item['id'])
      when "pois"
        content = Poi.find(item['id'])
      end
      unless content.nil?
        out << content.as_json(except: %i[puntajes puntaje]).merge(type: item['type'])
      end
    end
    render json: out, status: :ok
  end
end
