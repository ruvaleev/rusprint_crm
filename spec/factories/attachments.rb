FactoryBot.define do
  factory :attachment do
    file ActionDispatch::Http::UploadedFile.new(:tempfile => File.new("#{Rails.root}/spec/spec_helper.rb"), :filename => "spec_helper.rb")
  end
end
