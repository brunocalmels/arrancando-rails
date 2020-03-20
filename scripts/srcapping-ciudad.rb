# rubocop:disable

# # https://maps.googleapis.com/maps/api/place/textsearch/json?query=carnicer%C3%ADa&location=-38.9356355,-67.9937539&key=AIzaSyBkCPG-1sCRn-vu-TJDc71xY-Ueprv1ZwM

# #!/bin/ruby
# # frozen_string_literal: true

# require 'optparse'

# options = {}

# banner = 'Uso: ./scrapping-ciudad.rb -c=<CIUDAD> [-la=<LATITUD> -lo=<LONGITUD>]'

# OptionParser.new do |opts|
#   opts.banner = banner

#   opts.on('-c', '--ciudad CIUDAD', 'Ciudad') { |v| options[:ciudad] = v }
#   opts.on('-la', '--latitud LATITUD', 'latitud') { |v| options[:latitud] = v }
#   opts.on('-lo', '--longitud LONGITUD', 'longitud') { |v| options[:longitud] = v }
# end.parse!

# if !options.empty? && !options[:ciudad].nil?

#   require 'nokogiri'
#   require 'open-uri'
#   require 'json'
#   require 'byebug'
#   require 'watir'

#   links = []

#   ciudad = options[:ciudad]

#   (caps - skip).times do |i|
#     links << "https://www.dilo.nu/#{serie}-#{season}x#{(i + skip + 1).to_s.rjust(2, '0')}/"
#   end

#   browser = Watir::Browser.new :firefox, headless: true

#   links.each_with_index do |link, index|
#     puts "Accediendo a #{link}"

#     begin
#       pagina = Nokogiri::HTML(open(link))

#       a = pagina.css('a').find { |a| a.text.index('clipwatching') && a.text.index('Reproducir en Subtitulado') }

#       if a && a['data-link']

#         pagina = Nokogiri::HTML(open(a['data-link']))

#         iframe = pagina.css('iframe')

#         # byebug

#         # puts iframe

#         if iframe && iframe[0] && iframe[0]['src']

#           browser.goto iframe[0]['src']

#           pagina = Nokogiri::HTML.parse(browser.html)

#           video = pagina.css('video')

#           if video && video[0] && video[0]['src']

#             puts "Escribiendo episodio #{(index + 1 + skip).to_s.rjust(2, '0')}"

#             f = File.open('dleps.sh', 'a')
#             f.write("axel -an 30 #{video[0]['src']} -o e#{(index + 1 + skip).to_s.rjust(2, '0')}.mp4\n")
#             f.close

#           end

#         end

#       end
#     rescue OpenURI::HTTPError => e
#       puts 'Error 404'
#       puts link
#     end
#   end

#   browser.close

# else
#   puts banner
# end

# rubocop:disable