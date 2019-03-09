require 'rails_helper'
require "cancan/matchers"

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'admin' do
    let(:role) { create(:role, name: 'admin')}
    let(:user) { create(:user, role: role) }
    
    context 'can manage all objects' do
      it { is_expected.to be_able_to(:manage, :all) }
    end
  end

  describe 'manager' do
    let(:role) { create(:role, name: 'manager')}
    let(:user) { create(:user, role: role) }

    context 'can manage all objects' do
      it { is_expected.to be_able_to(:manage, :all) }
    end
  end

  describe 'master' do
    let(:role) { create(:role, name: 'master')}
    let(:user) { create(:user, role: role) }

    context 'can manage own orders' do
      let(:order) { create(:order, master: user)}
      it { is_expected.to be_able_to(:manage, order) }
    end

    context "cannot manage other master's orders" do
      let(:order) { create(:order)}
      it { is_expected.to_not be_able_to(:manage, order) }
    end

    context 'can manage himself' do
      it { is_expected.to be_able_to(:manage, user) }
    end

    context 'cannot manage other users' do
      let(:another_user) { create(:user) }
      it { is_expected.to_not be_able_to(:manage, another_user) }
    end

    context 'can edit companies' do
      let(:company) { create(:company) }
      it { is_expected.to be_able_to(:update, company) }
    end
  end
end
