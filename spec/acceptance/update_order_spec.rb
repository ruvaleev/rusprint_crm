require_relative 'acceptance_helper'

feature 'Update order', '
  In order to edit an order in orders table
  As an authentificated user
  I wanted to input edited data
' do

  given(:manager_role) { create(:manager_role) }
  given(:manager) { create(:user, role: manager_role) }
  given!(:customer) { create(:customer) }
  given(:printer_service_guide) { create(:printer_service_guide) }
  given(:printer) { create(:printer, company: customer, printer_service_guide: printer_service_guide) }
  given(:new_printer_service_guide) { create(:printer_service_guide, model: 'new_printer_HP') }
  given(:cartridge) { create(:cartridge_service_guide, printer_service_guide: printer_service_guide) }

  scenario 'Non-authentificated user cannot see orders table' do
    visit root_path

    expect(page).to_not have_css 'table'
  end

  context 'Manager or admin' do
    scenario 'updates printers'
    scenario 'updates cartridges'
    scenario 'updates quantity of units'
    scenario 'updates date of complete'
    scenario 'updates suitable time start'
    scenario 'updates suitable time end'
    scenario 'updates additional data'
    scenario 'updates revenue'
    scenario 'updates status'
    scenario 'updates expense'
    scenario 'chooses manager'
    scenario 'chooses master'
    scenario 'chooses provider'
    scenario 'cannot change date of order'
  end

  context 'Master' do
  end
end
