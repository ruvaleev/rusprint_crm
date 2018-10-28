class Price < ApplicationRecord
  mount_uploader :file, PriceUploader

  def vendor(model)
    labels = []
    Printer::VENDORS.each do |vendor|
      labels << vendor if model.include?(vendor)
    end
    result = labels[0] unless labels.size > 1
  end

  def parse
    file = File.read("public#{self.file.url}")
    csv = CSV.parse(file, headers: true)
    catalog = []
    csv.each do |row|
      catalog << row.to_hash
    end

    catalog.each do |catalog|
      catalog["Модель принтера"].include?('Color') ? color = 'true' : color = 'false'
      vendor = vendor(catalog["Модель принтера"])
      psg = PrinterServiceGuide.where(model: catalog["Модель принтера"].delete(vendor)[1..-1]).first_or_initialize
      psg.vendor = vendor
      psg.color = color
      psg.save
      errors = []
      errors << psg.errors.messages if psg.errors.any?
      if catalog["Модель картриджа"]
        color == 'true' ? cartridge_color = 'color' : cartridge_color = 'black' 
        csg = psg.cartridge_service_guide.where(model: catalog["Модель картриджа"]).first_or_initialize 
        csg.toner_life_count = catalog["Ресурс"] 
        csg.price = catalog['1-2 шт']|| 'уточняйте у менеджера'
        csg.color = cartridge_color
        csg.save
        errors << csg.errors.messages if csg.errors.any?
      end
      if errors.empty?
        @message = "Ваш прайс успешно загружен"
      else
        @message = "При загрузке произошли следующие ошибки: #{errors}"
      end
    end
  end
end