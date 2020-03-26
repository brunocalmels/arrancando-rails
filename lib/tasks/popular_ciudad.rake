require "#{Rails.root}/app/helpers/content_helper"

namespace :popular_ciudad do
  desc "Popula ciudades obtenidas a partir de scripts/scrapping-ciudad.rb"
  task :run, [:nombre_ciudad] => [:environment] do |_task, args|
    include ContentHelper

    ciudads = Ciudad.where(nombre: args[:nombre_ciudad])
    if ciudads.count > 0
      ciudad = ciudads.first
      if ciudads.count > 1
        puts "Hay más de 1 ciudad con ese nombre, ¿cuál hay que cargar?"
        ciudads.each_with_index do |c, i|
          puts "#{i}: #{c.nombre} (#{c.provincia.nombre})"
        end
        STDOUT.puts "Opcion: "
        input = STDIN.gets.strip
        ciudad = ciudads[input.to_i] || ciudads.first
      end

      if ciudad && !ciudad.populada

        # rubocop:disable Metrics/LineLength

        puts `cd #{Rails.root.join("scripts")}; ruby #{Rails.root.join("scripts", "srcapping-ciudad.rb")} --ciudad='#{ciudad.nombre}' --provincia='#{ciudad.provincia.nombre}' --apikey='#{ENV["MAPS_API_KEY"]}' --pais='#{ciudad.provincia.pais.nombre}'`

        # rubocop:enable Metrics/LineLength

        ciudad_json = JSON.parse(
          File.read(
            Rails.root.join(
              "scripts",
              "Resultados",
              ciudad.provincia.pais.nombre.gsub(" ", "_"),
              ciudad.provincia.nombre.gsub(" ", "_"),
              "#{ciudad.nombre.gsub(' ', '_')}.json"
            )
          )
        )

        ciudad_json.keys.each do |rubro|
          ciudad_json[rubro].each do |item|
            unless Poi.where(
              titulo: item["name"],
              lat: item["geometry"]["location"]["lat"],
              long: item["geometry"]["location"]["lng"]
            ).count == 0
              next
            end

            puts "Creando POI #{item['name']}"
            poi = Poi.create!(
              titulo: item["name"],
              cuerpo: item["name"],
              lat: item["geometry"]["location"]["lat"],
              long: item["geometry"]["location"]["lng"],
              direccion: item["formatted_address"],
              puntajes: {},
              user: User.first,
              categoria_poi: CategoriaPoi.first
            )
            begin
              get_maps_image(poi, item)
            rescue StandardError => e
              puts e
            end
          end
        end

        git_version = `git rev-parse HEAD`

        ciudad.update(
          populada: true,
          fecha_populacion: Time.zone.now,
          version_script_populacion: git_version.strip,
          rubros: ciudad_json.keys
        )

      end
    end
  end
end
