require_relative 'acceptance_helper'

feature 'Destroy order', '
  In order to destroy an order in orders table
  As an authentificated user
  I wanted to click button and destroy order
' do

  given(:manager_role) { create(:manager_role) }
  given(:admin_role) { create(:admin_role) }
  given(:master_role) { create(:master_role) }
  given(:manager) { create(:user, role: manager_role) }
  given(:admin) { create(:user, role: admin_role) }
  given(:master) { create(:user, role: master_role) }
  given!(:order) { create(:order) }

  scenario 'Non-authentificated user cannot see destroy button' do
    visit root_path
    expect(page).to_not have_button "destroy_order_#{order.id}"
  end

  context 'Manager' do
    before do
      sign_in(manager)
      visit root_path
    end

    before do
      expect(page).to have_css("tr#row_#{order.id}")
      find("#destroy_order_#{order.id}").click
    end

    scenario 'destroys order' do
      expect(page).to_not have_css("tr#row_#{order.id}")
    end

    scenario 'see success message' do
      expect(page).to have_content("Заказ #{order.id} удален")
    end
  end

  context 'Admin' do
    before do
      sign_in(admin)
      visit root_path
    end

    before do
      expect(page).to have_css("tr#row_#{order.id}")
      find("#destroy_order_#{order.id}").click
    end

    scenario 'destroys order' do
      expect(page).to_not have_css("tr#row_#{order.id}")
    end

    scenario 'see success message' do
      expect(page).to have_content("Заказ #{order.id} удален")
    end
  end

  context 'Master' do
    before do
      sign_in(master)
      visit root_path
    end

    scenario 'master cannot destroy order' do
      expect(page).to_not have_button "destroy_order_#{order.id}"
    end
  end
end
