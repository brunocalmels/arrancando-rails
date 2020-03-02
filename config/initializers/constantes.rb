# PROVINCIAS = [
#   {
#     nombre: "Neuquén",
#     ciudades: %w[
#       Neuquén
#       Plottier
#     ],
#   },
#   {
#     nombre: "Río Negro",
#     ciudades: [
#       "Cipolletti",
#       "Fernández Oro",
#     ],
#   },
# ].freeze

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

APP_VERSION = "1.1.5+20".freeze
