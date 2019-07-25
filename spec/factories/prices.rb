FactoryBot.define do
  factory :price, class: 'Price' do
    file do
      ActionDispatch::Http::UploadedFile
        .new(tempfile: File.new(Rails.root.join('spec', 'fixtures', 'files', 'price.csv')), filename: 'price.csv')
    end
  end
end
