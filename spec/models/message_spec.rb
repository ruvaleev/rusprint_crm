require 'rails_helper'

RSpec.describe Message, type: :model do

  it { should belong_to :sender }
  it { should belong_to :receiver }

  it { should validate_presence_of :body }

end