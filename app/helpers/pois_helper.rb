module PoisHelper
  def filter_by_categria_poi_id
    return unless params.key? :categoria_poi_id

    @pois = @pois
            .where(categoria_poi_id: params[:categoria_poi_id].to_i)
  end

  def filter_by_term
    return unless params.key? :term

    @pois = @pois
            .search(params[:term])
  end

  def filter_habilitados
    @pois = @pois.habilitados
  end

  def inferir_provincia
    @provincia = Provincia.find_by_nombre(params[:nombre_provincia])
    return unless @provincia.nombre == "Buenos Aires"

    @provincia2 = Provincia.find_by_nombre("Capital Federal")
  end

  def inferir_ciudad
    return unless params.key?(:nombre_ciudad) && params.key?(:nombre_provincia)

    inferir_provincia

    ciudad = Ciudad.find_by_nombre(params[:nombre_ciudad])
    unless ciudad.provincia_id == @provincia.id ||
           (@provincia2 && ciudad.provincia_id == @provincia2.id)
      return
    end

    @poi.ciudad = ciudad
  end
end
