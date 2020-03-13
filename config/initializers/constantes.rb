PROVINCIAS_VIEJAS = [
  {
    nombre: "Neuquén",
    ciudades: %w[
      Neuquén
      Plottier
    ]
  },
  {
    nombre: "Río Negro",
    ciudades: [
      "Cipolletti",
      "Fernández Oro"
    ]
  }
].freeze

CATEGORIAS_PUBLICACIONES = %w[
  Comunidad
  Sponsors
  Publicidad
  Promos
  Ranking
].freeze

CATEGORIAS_RECETAS = %w[
  Asador
  Marinados
  Parrilla
].freeze

CATEGORIAS_POIS = [
  "Carne",
  "Verdura",
  "Leña",
  "Artesanos del hierro"
].freeze

MAX_ATTACHMENT_SIZE_BYTES = 12.megabytes
MAX_IMAGE_WIDTH_APP = 800
MAX_IMAGE_HEIGHT_APP = 600
MAX_IMAGE_WIDTH_WEB = 600
MAX_IMAGE_HEIGHT_WEB = 400
MIN_IMAGE_SIZE_TO_ENFORCE_COMPRESSION = 300.kilobytes
COMPRESSED_IMAGE_WIDTH = 1400
COMPRESSED_IMAGE_HEIGHT = 1000
MAX_REPORTE_SHORT_LENGTH = 60

ARRANCANDO_URL = "https://arrancando.com.ar".freeze
ANDROID_DOWNLOAD_URL = "https://play.google.com/store/apps/details?id=com.macherit.arrancando".freeze
IOS_DOWNLOAD_URL = "https://apps.apple.com/us/app/arrancando/id1490590335?l=es".freeze

APP_VERSION = "1.1.8+23".freeze
# APP_VERSION = "1.1.10+25".freeze
