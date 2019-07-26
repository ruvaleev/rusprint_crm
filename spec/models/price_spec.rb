# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Price, type: :model do
  describe '#parse' do
    let(:price) { create(:price) }
    before do
      allow(PriceImport).to receive_message_chain(:new, :run).and_return('Import Service Run')
    end

    it 'calls PriceImport service' do
      expect(price.parse).to eq 'Import Service Run'
    end
  end
end
