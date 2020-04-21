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

CATEGORIAS_RECETAS_V2 = %w[
  Parrilla
  Asador
  Olla
  Plancha
  Disco
  Horno
  Sartén
  Bowl
  Wok
].freeze

COMPLEJIDADES_RECETAS = %w[
  Fácil
  Media
  Compleja
].freeze

CATEGORIAS_POIS = [
  "Carne",
  "Verdura",
  "Leña",
  "Artesanos del hierro"
].freeze

CONTROLADORES_PUBLICOS = %w[publicaciones recetas pois].freeze
ACCIONES_PUBLICAS = ["show"].freeze

MAX_ATTACHMENT_SIZE_BYTES = 12.megabytes
MAX_IMAGE_WIDTH_APP = 800
MAX_IMAGE_HEIGHT_APP = 600
MAX_IMAGE_WIDTH_WEB = 600
MAX_IMAGE_HEIGHT_WEB = 400
MAX_IMAGE_WIDTH_METATAG = 300
MAX_IMAGE_HEIGHT_METATAG = 300
MIN_IMAGE_SIZE_TO_ENFORCE_COMPRESSION = 300.kilobytes
COMPRESSED_IMAGE_WIDTH = 1400
COMPRESSED_IMAGE_HEIGHT = 1000
MAX_REPORTE_SHORT_LENGTH = 60

THUMB_SIZE = 350
WEB_THUMB_SIZE = 250
WEB_COMMENT_THUMB_SIZE = 125
MAX_SIZE_POI_IMAGE = 400

ARRANCANDO_URL = "https://arrancando.com.ar".freeze
ANDROID_DOWNLOAD_URL = "https://play.google.com/store/apps/details?id=com.macherit.arrancando".freeze
IOS_DOWNLOAD_URL = "https://apps.apple.com/us/app/arrancando/id1490590335?l=es".freeze

APP_VERSION = "1.2.7+43".freeze
