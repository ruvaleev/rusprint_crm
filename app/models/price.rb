class Price < ApplicationRecord
  mount_uploader :file, PriceUploader

  def parse
    # Распарсиваем файл в строки
    file = File.read("public#{self.file.url}")
    PriceImport.new(file).run
  end
end
