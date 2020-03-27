# Scripts para corregir las ciudades de los PoIs incorrectamente cargados.
# Se usa para corregir los cargados inicialmente, que quedaron todos como
# si fueran de Nequen.
# Tambien se los podria utilizar para corregir carga automatica si toman
# un area demasiado grande.

# CIPOLLETTI
l = {
  lat_sup: -38.9054188,
  lat_inf: -38.9591568,
  long_izq: -68.027099,
  long_der: -67.964776
}

# Cambia todos los PoIs dentro del rect.
Poi.where("pois.lat > ? AND pois.lat < ? AND pois.long > ? AND pois.long < ?",
          l[:lat_inf],
          l[:lat_sup],
          l[:long_izq],
          l[:long_der]).update_all(ciudad_id: 3)

# Cambia los q digan en su direccion la palabra Cipolletti
Poi.where("pois.direccion like ?",
          "%Cipolletti%").where("pois.ciudad_id != ?",
                                3).update_all(ciudad_id: 3)

# PLOTTIER
l = {
  lat_sup: -38.9238481,
  lat_inf: -38.9632124,
  long_izq: -68.3072992,
  long_der: -68.1764836
}

Poi.where("pois.lat > ? AND pois.lat < ? AND pois.long > ? AND pois.long < ?",
          l[:lat_inf],
          l[:lat_sup],
          l[:long_izq],
          l[:long_der]).update_all(ciudad_id: 2)

Poi.where("pois.direccion like ?",
          "%Plottier%").where("pois.ciudad_id != ?",
                              2).update_all(ciudad_id: 2)
