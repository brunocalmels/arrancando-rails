namespace :datos_geograficos do
  desc "Reemplaza las provincias y ciudades iniciales por lista completa"
  task reemplazar_ciudades_y_provincias: :environment do
    provs_a_borrar = Provincia.ids

    PROVINCIAS_EXISTENTES.each do |prov|
      Provincia.create(id: prov.first, nombre: prov.second)
    end

    # Cambia la provincia de referencia de las ciudades por las nuevas
    Ciudad.where(provincia_id: 1).update_all provincia_id: 16 # Neuquen
    Ciudad.where(provincia_id: 2).update_all provincia_id: 17 # Rio Negro

    Provincia.find(provs_a_borrar).each(&:destroy)

    # Crea las nuevas provincias y ciudades
    PROVINCIAS_NUEVAS.each do |prov|
      Provincia.create(id: prov.first, nombre: prov.second)
    end
    CIUDADES_NUEVAS.each do |ciudad|
      Ciudad.create(id: ciudad.first,
                    provincia_id: ciudad.second,
                    nombre: ciudad.third)
    end
  end
end
