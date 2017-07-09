# module para definir en un solo lugar todos los monkey patches, organizados de manera conveniente
# (por funcionalidad, por clase). Estos monkey patches se incluyen al proyecto en config/initializers/core_extensions_initializer.rb,
# en donde se pueden agregar o quitar modulos segun sea necesario
module CoreExtensions
  module String
    def strip_accent_marks
      self.gsub('á','a').gsub('é','e').gsub('í','i').gsub('ó', 'o').gsub('ú','u')
    end
  end
end