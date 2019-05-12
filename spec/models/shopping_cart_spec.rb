# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShoppingCart do
  it { should have_one :order }
end
