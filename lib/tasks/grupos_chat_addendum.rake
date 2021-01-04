namespace :grupos_chat do
  desc "Agrega nuevos grupos a los que se crearon inicialmente"
  task create_grupos_chat_v2: :environment do
    GRUPOS_CHAT_V2.each do |grupo|
      GrupoChat.create(
        nombre: grupo[:nombre],
        simbolo: grupo[:simbolo],
        color: grupo[:color]
      )
    end
  end
end

GRUPOS_CHAT_V2 = [
  {
    nombre: "Conservas",
    simbolo: "CON",
    color: "#28A38C"
  },
  {
    nombre: "Birreros",
    simbolo: "BIR",
    color: "#C0B430"
  },
  {
    nombre: "Pizzeros",
    simbolo: "PIZ",
    color: "#D96D30"
  },
  {
    nombre: "Panaderos",
    simbolo: "PAN",
    color: "#C68106"
  }
].freeze
