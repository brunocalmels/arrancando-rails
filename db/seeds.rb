# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

FactoryBot.create(
  :user,
  rol: :admin,
  email: "b@m.c",
  nombre: "Bruno",
  apellido: "Calmels",
  username: "bru",
  password: "123456",
  activo: true
)

FactoryBot.create(
  :user,
  rol: :admin,
  email: "i@m.c",
  nombre: "Ivan",
  apellido: "Eidelstein",
  username: "ivan",
  password: "123456",
  activo: true
)

FactoryBot.create(
  :user,
  rol: :admin,
  email: "mt@mtgroupsrl.com.ar",
  nombre: "Matías",
  apellido: "Tonelli",
  username: "masterAsadero",
  password: "123456",
  activo: true
)

PROVINCIAS_VIEJAS.each do |prov|
  provincia = Provincia.create(nombre: prov[:nombre])
  prov[:ciudades].each do |ciudad|
    Ciudad.create(nombre: ciudad, provincia: provincia)
  end
end
# Si se usa esta creación de Provincias y Ciudades, correr el task luego
# en caso de querer la lista extensiva de ciudades y provincias.

# Sino, usar directamente ésta
# PROVINCIAS.each do |prov|
#   Provincia.create(id: prov.first, nombre: prov.second)
# end
# CIUDADES.each do |ciudad|
#   Ciudad.create(id: ciudad.first, provincia_id: ciudad.second, nombre: ciudad.third)
# end

10.times { FactoryBot.create(:publicacion) }

CATEGORIAS_RECETAS.each do |cat|
  CategoriaReceta.create(nombre: cat)
end
10.times { FactoryBot.create(:receta) }

CATEGORIAS_POIS.each do |cat|
  CategoriaPoi.create(nombre: cat)
end

# 10.times { FactoryBot.create(:poi) }
carnicerias = JSON.parse(File.read(File.join(Rails.root, "app/assets/data/carnicerías.json"))).take(10)
verdulerias = JSON.parse(File.read(File.join(Rails.root, "app/assets/data/verdulerías.json"))).take(10)

def get_maps_image(poi, item)
  unless item["photos"] && item["photos"][0] && item["photos"][0]["photo_reference"]
    return
  end

  max_size = 400
  downloaded_image = URI.parse("https://maps.googleapis.com/maps/api/place/photo?photoreference=#{item['photos'][0]['photo_reference']}&sensor=false&maxheight=#{max_size}&maxwidth=#{max_size}&key=AIzaSyBkCPG-1sCRn-vu-TJDc71xY-Ueprv1ZwM").open
  poi.imagenes.attach(io: downloaded_image, filename: "#{poi.id}-maps-image.jpg")
end

carnicerias.each do |c|
  poi = Poi.create!(
    titulo: c["name"],
    cuerpo: c["name"],
    lat: c["geometry"]["location"]["lat"],
    long: c["geometry"]["location"]["lng"],
    direccion: c["formatted_address"],
    puntajes: {},
    user: User.first,
    categoria_poi: CategoriaPoi.first
  )
  get_maps_image(poi, c)
end

verdulerias.each do |c|
  poi = Poi.create!(
    titulo: c["name"],
    cuerpo: c["name"],
    lat: c["geometry"]["location"]["lat"],
    long: c["geometry"]["location"]["lng"],
    direccion: c["formatted_address"],
    puntajes: {},
    user: User.first,
    categoria_poi: CategoriaPoi.second
  )
  get_maps_image(poi, c)
end
