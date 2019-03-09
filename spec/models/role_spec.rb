require 'rails_helper'

RSpec.describe Role do
  it { should have_many :users }
end
