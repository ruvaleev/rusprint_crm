FactoryBot.define do
  factory :price_csv_file do
    file ActionDispatch::Http::UploadedFile.new(:tempfile => File.new("#{Rails.root}/spec/fixtures/files/price.csv"), :filename => "price.csv")
  end
end
