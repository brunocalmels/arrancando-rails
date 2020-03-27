#!/bin/ruby
# frozen_string_literal: true

require "optparse"

options = {}

banner = "Uso: ./scrapping-ciudad.rb -c=<CIUDAD> -p=<PROVINCIA> -k=<API_KEY> [-pa=<PAIS>]"
# banner = 'Uso: ./scrapping-ciudad.rb -c=<CIUDAD> -p=<PROVINCIA> [-pa=<PAIS> -la=<LATITUD> -lo=<LONGITUD>]'

OptionParser.new do |opts|
  opts.banner = banner

  opts.on("-c", "--ciudad CIUDAD", "Ciudad") { |v| options[:ciudad] = v }
  opts.on("-p", "--provincia PROVINCIA", "Provincia") { |v| options[:provincia] = v }
  opts.on("-k", "--apikey API_KEY", "API Key") { |v| options[:apikey] = v }
  opts.on("-pa", "--pais PAIS", "País") { |v| options[:pais] = v }
  # opts.on('-la', '--latitud LATITUD', 'latitud') { |v| options[:latitud] = v }
  # opts.on('-lo', '--longitud LONGITUD', 'longitud') { |v| options[:longitud] = v }
  opts.on("-r", "--rubros cat1,cat2,cat3", "Rubros") do |v|
    options[:rubros] = Array.new(v.split(","))
  end
end.parse!

if !options.empty? && !options[:ciudad].nil? && !options[:provincia].nil? && !options[:apikey].nil?
  # if !options.empty? && ((!options[:ciudad].nil? && !options[:provincia].nil?) || (!options[:latitud].nil? && !options[:longitud].nil?))

  require "json"
  require "net/http"
  require "fileutils"

  ciudad = options[:ciudad]
  provincia = options[:provincia]
  API_KEY = options[:apikey]
  pais = options[:pais] || "Argentina"

  puts "Obteniendo latitud y longitud de la ciudad"

  uri = URI(URI.escape("https://maps.googleapis.com/maps/api/geocode/json?address=#{ciudad.gsub(" ", "+")},+#{provincia.gsub(" ", "+")},+#{pais.gsub(" ", "+")}&key=#{API_KEY}"))
  res = Net::HTTP.get(uri)

  geocode_ciudad = JSON[res]

  latitud = geocode_ciudad["results"][0]["geometry"]["location"]["lat"]
  longitud = geocode_ciudad["results"][0]["geometry"]["location"]["lng"]

  puts "Obteniendo listado de comercios"

  output = {}

  rubros = options[:rubros]
  rubros.each do |rubro|
    puts "Obteniendo rubro #{rubro}"

    output[rubro] = []
    i = 1
    puts "Página #{i}"

    uri = URI(URI.escape("https://maps.googleapis.com/maps/api/place/textsearch/json?query=#{rubro}&location=#{latitud},#{longitud}&key=#{API_KEY}"))
    res = Net::HTTP.get(uri)
    data = JSON[res]

    output[rubro] = output[rubro] + data["results"]

    i += 1

    while data["next_page_token"]
      puts "Página #{i}"
      sleep 2
      uri = URI(URI.escape("https://maps.googleapis.com/maps/api/place/textsearch/json?pagetoken=#{data["next_page_token"]}&key=#{API_KEY}"))
      res = Net::HTTP.get(uri)
      data = JSON[res]
      output[rubro] = output[rubro] + data["results"]
      i += 1
    end
  end

  path = "Resultados/#{pais.gsub(" ", "_")}/#{provincia.gsub(" ", "_")}/#{ciudad.gsub(" ", "_")}.json"
  dirname = File.dirname(path)
  unless File.directory?(dirname)
    FileUtils.mkdir_p(dirname)
  end

  puts "Guardando en #{path}"

  f = File.open("#{path}", "w")
  f.write(output.to_json)
  f.close
else
  puts banner
end
