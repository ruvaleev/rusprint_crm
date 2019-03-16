# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  it { should belong_to :order }
  it { should belong_to :item }
end
