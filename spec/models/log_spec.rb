require 'rails_helper'

RSpec.describe Log, type: :model do
  it { should belong_to :user }
  it { should belong_to :registerable }

  it { should validate_presence_of :body }
end
