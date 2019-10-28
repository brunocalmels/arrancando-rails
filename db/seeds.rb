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

PROVINCIAS.each do |prov|
  provincia = Provincia.create(nombre: prov[:nombre])
  prov[:ciudades].each do |ciudad|
    Ciudad.create(nombre: ciudad, provincia: provincia)
  end
end

10.times { FactoryBot.create(:publicacion) }

CATEGORIAS_RECETAS.each do |cat|
  CategoriaReceta.create(nombre: cat)
end
10.times { FactoryBot.create(:receta) }
