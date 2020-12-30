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

SUBCATEGORIAS_RECETAS = [
  "Carne roja",
  "Carne blanca",
  "Vegatales",
  "Frutos",
  "Frutos secos",
  "Especias"
].freeze

COMPLEJIDADES_RECETAS = %w[
  Fácil
  Media
  Difícil
].freeze

CATEGORIAS_POIS = [
  "Carne",
  "Verdura",
  "Leña",
  "Artesanos del hierro"
].freeze

CONTROLADORES_PUBLICOS = %w[publicaciones recetas pois].freeze
ACCIONES_PUBLICAS = ["show"].freeze

PERMITTED_IMAGE_TYPES = [
  "image/jpg",
  "image/jpeg",
  "image/png",
  "image/gif"
].freeze

PERMITTED_VIDEO_TYPES = [
  "video/mp4",
  "video/mpg",
  "video/mpeg",
  "video/quicktime"
].freeze

PERMITTED_MIME_TYPES = (PERMITTED_IMAGE_TYPES + PERMITTED_VIDEO_TYPES).flatten

MAX_ATTACHMENT_SIZE_BYTES = 15.megabytes
MAX_IMAGE_WIDTH_APP = 800
MAX_IMAGE_HEIGHT_APP = 1000
MAX_IMAGE_WIDTH_WEB = 800
MAX_IMAGE_HEIGHT_WEB = 1000
# MAX_IMAGE_WIDTH_WEB = 600
# MAX_IMAGE_HEIGHT_WEB = 400
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

DEFAULT_INDEX_ACTION_CACHE_DURATION = 2.hours

ARRANCANDO_URL = "https://arrancando.com.ar".freeze
ANDROID_DOWNLOAD_URL = "https://play.google.com/store/apps/details?id=com.macherit.arrancando".freeze
IOS_DOWNLOAD_URL = "https://apps.apple.com/us/app/arrancando/id1490590335?l=es".freeze

APP_VERSION = "2.1.0+56".freeze

FIREBASE_FCM_KEY = "AAAAiFZRHCA:APA91bG_EBPE9Eq0xb0CsoCOHlhzSe6rmNrye6fiJjA4V06RrQH8CeNNhaFMGCRPoRU-myhyIW_IY95NiuJn2LQkaXlRIefe8qvKmUJpOcUb8NAblawEb9GPV6yrbF8h65o2qMf-_8oe".freeze

LIKES_TO_COLOR = {
  [0, 6] => "verde",
  [6, 11] => "cobre",
  [11, 21] => "bronce",
  [21, 31] => "plata",
  [31, Float::INFINITY] => "oro"
}.freeze
