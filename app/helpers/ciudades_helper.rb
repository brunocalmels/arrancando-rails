module CiudadesHelper
  def users_count_query
    Ciudad
      .select("
            ciudades.*,
            provincias.nombre AS provincia_nombre,
            COUNT(DISTINCT(users.id)) AS users_count
            ")
      .joins("
            ciudades
            JOIN provincias ON provincias.id = ciudades.provincia_id
            FULL JOIN users ON users.ciudad_id = ciudades.id
          ")
      .group("ciudades.id, provincias.id")
      .order("users_count DESC")
  end

  def publicaciones_count_query
    Ciudad
      .select("
        ciudades.*,
        provincias.nombre AS provincia_nombre,
        COUNT(DISTINCT(publicaciones.id)) AS publicaciones_count
        ")
      .joins("
          ciudades
          JOIN provincias ON provincias.id = ciudades.provincia_id
          FULL JOIN publicaciones ON publicaciones.ciudad_id = ciudades.id
          ")
      .group("ciudades.id, provincias.id")
      .order("publicaciones_count DESC")
  end

  def pois_count_query
    Ciudad
      .select("
        ciudades.*,
        provincias.nombre AS provincia_nombre,
        COUNT(DISTINCT(pois.id)) AS pois_count
        ")
      .joins("
          ciudades
          JOIN provincias ON provincias.id = ciudades.provincia_id
          FULL JOIN pois ON pois.ciudad_id = ciudades.id
          ")
      .group("ciudades.id, provincias.id")
      .order("pois_count DESC")
  end

  def ciudades_index_query
    Ciudad
      .select("
            ciudades.*,
            provincias.nombre AS provincia_nombre
            ")
      .joins("
            ciudades
            JOIN provincias ON provincias.id = ciudades.provincia_id
          ")
      .group("ciudades.id, provincias.id")
  end

  # def ciudades_index_full_query
  #   Ciudad
  #     .select("
  #           ciudades.*,
  #           provincias.nombre AS provincia_nombre,
  #           COUNT(DISTINCT(publicaciones.id)) AS publicaciones_count,
  #           COUNT(DISTINCT(users.id)) AS users_count,
  #           COUNT(DISTINCT(pois.id)) AS pois_count
  #           ")
  #     .joins("
  #           ciudades
  #           JOIN provincias ON provincias.id = ciudades.provincia_id
  #           FULL JOIN publicaciones ON publicaciones.ciudad_id = ciudades.id
  #           FULL JOIN users ON users.ciudad_id = ciudades.id
  #           FULL JOIN pois ON pois.ciudad_id = ciudades.id
  #         ")
  #     .group("ciudades.id, provincias.id")
  # end
end
