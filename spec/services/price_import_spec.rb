require 'rails_helper'

RSpec.describe PriceImport do
  let!(:price_csv_file) { File.read(Rails.root.join('spec', 'fixtures', 'files', 'price.csv')) }
  let!(:processor) { described_class.new(price_csv_file) }
  let(:new_row) do
    "\r\nHP NewSeries NewPrinterModel_1 / NewPrinterModel_2 / NewPrinterModel_3,Cartridge Model_1,30000,0,0,0,1000,0"
  end

  it 'creates printer service guides' do
    expect { processor.run }.to change(PrinterServiceGuide, :count)
  end

  it 'creates cartridge service guides' do
    expect { processor.run }.to change(CartridgeServiceGuide, :count)
  end

  context 'when Printers and Cartridges already exists' do
    before { processor.run }

    it 'creates printer service guides' do
      expect { processor.run }.to_not change(PrinterServiceGuide, :count)
    end

    it 'creates cartridge service guides' do
      expect { processor.run }.to_not change(CartridgeServiceGuide, :count)
    end
  end

  context 'Correctness values of saved models' do
    before do
      price_csv_file.concat(new_row)
      described_class.new(price_csv_file).run
      @printer = PrinterServiceGuide.find_by(model: 'NewPrinterModel_1')
      @cartridge = CartridgeServiceGuide.where(model: 'Cartridge Model_1').first
    end

    it 'creates correct associations' do
      expect(@printer.cartridges.first).to eq @cartridge
    end

    it 'creates correct price' do
      expect(@cartridge.price).to eq '1000'
    end

    it 'creates correct vendor' do
      expect(@printer.vendor).to eq 'hp'
    end
  end
  it 'parses empty rows'
  it 'shows errors'
end
