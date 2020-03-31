class CiudadesImport
  include ActiveModel::Model
  require "csv"

  attr_accessor :file

  def initialize(attributes={})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def read_file
    case File.extname(file.original_filename)
    when ".csv" then CSV.read(file.path)
    else raise "Tipo de archivo incorrecto. Sólo se aceptan .csv."
    end
  end

  def imported_ciudades
    @imported_ciudades ||= load_imported_ciudades
  end

  def load_imported_ciudades
    ciudades_file = read_file
    ciudades = ciudades_file.map do |fila|
      pais = Pais.find_by_nombre(fila[2].strip)
      ciudad = Ciudad.new(
        nombre: fila[0].strip,
        provincia: pais.provincias.find_by_nombre(fila[1].strip)
      )
      if ciudad.valid?
        ciudad
      else
        @msje_error += "#{ciudad.nombre} - \
                        #{ciudad.provincia.nombre} - \
                        #{ciudad.pais.nombre}: \
                        #{ciudad.errors.full_messages.join(', ')}. "
        nil
      end
    rescue StandardError => e
      @msje_error += "Fila '#{fila}': #{e}. "
      nil
    end
    ciudades.compact
  end

  def save
    count = 0
    @msje_success = " "
    @msje_error = " "
    imported_ciudades.each do |ciu|
      if ciu.save
        count += 1
        @msje_success += " #{ciu.nombre} - \
                          #{ciu.provincia.nombre} - \
                          #{ciu.pais.nombre}: OK. "
      else
        @msje_error += "#{ciu.nombre} - #{ciu.provincia.nombre} - \
                        #{ciu.pais.nombre}: \
                        #{ciu.errors.full_messages.join(', ')}. "
      end
    end
    { cant: count, msje_error: @msje_error, msje_success: @msje_success }
  end
end
