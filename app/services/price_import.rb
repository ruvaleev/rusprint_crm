class PriceImport
  def initialize(file)
    @catalog = CSV.parse(file, headers: true).map(&:to_hash)
    @row_result = Hash.new(0)
  end

  def run
    @catalog.each { |row| process(row) }
  end

  private

  def process(row)
    # Распарсиваем строку
    parse_row(row)
    # Создаем принтеры и картриджи (либо обновляем цены по ним)
    save_or_update_row
  end

  def parse_row(row)
    @model_array = row['Модель принтера'].gsub(/[[:space:]]/, ' ').split(' ')
    extract_printer_models
    extract_vendor

    @row_result[:series]          = @model_array.join.gsub(/\A\p{Space}*|\p{Space}*\z/, '')
    @row_result[:cartridge_model] = row['Модель картриджа']
    @row_result[:resource]        = row['Ресурс, копий']
    @row_result[:price]           = row['1-2 шт']
    @row_result[:color]           = row['color'] || 'black'
  end

  def save_or_update_row
    # Здесь мы можем создавать принтеры и на каждый принтер - картридж (чтобы айдишники захватить)
    @row_result[:printer_models].each do |printer_model|
      # Проверяем, есть ли такие принтеры
      printer =
        PrinterServiceGuide.where('lower(model) LIKE ? AND lower(vendor) LIKE ?',
                                  printer_model.downcase.strip, @row_result[:vendor]).last
      # Если нет, то создаем
      printer ||= PrinterServiceGuide.create(vendor: @row_result[:vendor],
                                             series: @row_result[:series],
                                             model: printer_model.strip)
      # Далее создаем для этого принтера картридж
      cartridge = printer.cartridge_service_guides.find_or_initialize_by(model: @row_result[:cartridge_model])
      cartridge.update(toner_life_count: @row_result[:resource],
                       price: @row_result[:price],
                       color: @row_result[:color])
    end
  end

  def extract_printer_models
    # Находим индекс первого слэша ('/')
    slash_index         = @model_array.index { |x| x.include?('/') } || @model_array.size
    first_printer_index = slash_index - 1
    # Все, что после после найденного элемента, мы отсекаем для дальнейшего распарсивания, в модели
    printers            = @model_array.slice!(first_printer_index, @model_array.size)
    # Убираем лишние знаки из массива принтеров
    printers.map { |p| printers.delete(p) if p.include?('/') }
    @row_result[:printer_models] = printers
  end

  def extract_vendor
    Printer::VENDORS.each do |vendor|
      value = @model_array.find { |str| str.downcase.include?(vendor.downcase) }
      next if value.nil?

      @row_result[:vendor] = vendor
      @model_array.delete(value)
      break
    end
  end
end
