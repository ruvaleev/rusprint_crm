# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ArchiveCompany do
  it { should belong_to(:user) }
  it { should belong_to(:company) }
end
