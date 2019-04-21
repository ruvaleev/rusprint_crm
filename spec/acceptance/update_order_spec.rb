require_relative 'acceptance_helper'

feature 'Update order', '
  In order to edit an order in orders table
  As an authentificated user
  I wanted to input edited data
' do

  given(:manager_role) { create(:manager_role) }
  given(:master_role) { create(:master_role) }
  given(:manager) { create(:user, role: manager_role) }
  given(:new_manager) { create(:user, role: manager_role, second_name: 'New manager secname') }
  given(:master) { create(:user, role: master_role) }
  given(:new_master) { create(:user, role: master_role, second_name: 'New master secname') }
  given!(:order) { create(:order, master: master, manager: manager) }
  given(:order_item) { create(:order_item, order: order) }

  scenario 'Non-authentificated user cannot see orders table' do
    visit root_path

    expect(page).to_not have_css 'table'
  end

  context 'Manager or admin', js: true do
    before do
      sign_in(manager)
    end
    xscenario 'updates printers' do
      bip_text order, :printers, 'Обновленные принтеры'
      within "#best_in_place_order_#{order.id}_printers" do
        expect(page).to have_content 'Обновленные принтеры'
      end
    end
    xscenario 'updates cartridges' do
      bip_text order, :cartridges, 'Обновленные картриджи'
      within "#best_in_place_order_#{order.id}_cartridges" do
        expect(page).to have_content 'Обновленные картриджи'
      end
    end

    scenario 'updates quantity of units' do
      bip_select order_item, :quantity, '10'
      within "#best_in_place_order_item_#{order_item.id}_quantity" do
        expect(page).to have_content '10'
      end
    end

    scenario 'updates date of complete' do
      bip_text order, :date_of_complete, '09.05.1945'
      within "#best_in_place_order_#{order.id}_date_of_complete" do
        expect(page).to have_content '09.05.1945'
      end
    end

    scenario 'updates suitable time start' do
      bip_select order, :suitable_time_start, '12:00'
      within "#best_in_place_order_#{order.id}_suitable_time_start" do
        expect(page).to have_content '12:00'
      end
    end

    scenario 'updates suitable time end' do
      bip_select order, :suitable_time_end, '13:30'
      within "#best_in_place_order_#{order.id}_suitable_time_end" do
        expect(page).to have_content '13:30'
      end
    end

    scenario 'updates additional data' do
      bip_area order, :additional_data, 'Мастер ввел сюда примечания'
      within "#best_in_place_order_#{order.id}_additional_data" do
        expect(page).to have_content 'Мастер ввел сюда примечания'
      end
    end

    scenario "updates cartridge's price" do
      bip_text order_item, :price_cents, '1010'
      within "#best_in_place_order_item_#{order_item.id}_price_cents" do
        expect(page).to have_content '1010'
      end
    end

    scenario 'updates status' do
      bip_select order, :status, 'Заказ выполнен'
      within "#best_in_place_order_#{order.id}_status" do
        expect(page).to have_content 'Заказ выполнен'
      end
    end

    scenario 'updates expense' do
      bip_text order, :expense, '200'
      within "#best_in_place_order_#{order.id}_expense" do
        expect(page).to have_content '200'
      end
    end

    scenario 'chooses manager' do
      bip_select order, :manager_id, new_manager.second_name
      within "#best_in_place_order_#{order.id}_manager_id" do
        expect(page).to have_content new_manager.second_name
      end
    end

    scenario 'chooses master' do
      bip_select order, :master_id, new_master.second_name
      within "#best_in_place_order_#{order.id}_master_id" do
        expect(page).to have_content new_master.second_name
      end
    end

    scenario 'chooses provider' do
      bip_select order, :provider, Order::PROVIDERS.last
      within "#best_in_place_order_#{order.id}_provider" do
        expect(page).to have_content Order::PROVIDERS.last
      end
    end

    scenario 'updates date of order' do
      bip_text order, :date_of_order, '09.05.1945'
      within "#best_in_place_order_#{order.id}_date_of_order" do
        expect(page).to have_content '09.05.1945'
      end
    end
  end

  context 'Master', js: true do
    before do
      sign_in(master)
    end

    scenario 'updates date of complete' do
      bip_text order, :date_of_complete, '09.05.1945'
      within "#best_in_place_order_#{order.id}_date_of_complete" do
        expect(page).to have_content '09.05.1945'
      end
    end

    scenario 'updates additional data' do
      bip_area order, :additional_data, 'Мастер ввел сюда примечания'
      within "#best_in_place_order_#{order.id}_additional_data" do
        expect(page).to have_content 'Мастер ввел сюда примечания'
      end
    end

    xscenario 'updates printers' do
      bip_text order, :printers, 'Обновленные принтеры'
      within "#best_in_place_order_#{order.id}_printers" do
        expect(page).to have_content 'Обновленные принтеры'
      end
    end

    xscenario 'updates cartridges' do
      bip_text order, :cartridges, 'Обновленные картриджи'
      within "#best_in_place_order_#{order.id}_cartridges" do
        expect(page).to have_content 'Обновленные картриджи'
      end
    end

    scenario 'updates quantity of units' do
      bip_select order_item, :quantity, '10'
      within "#best_in_place_order_item_#{order_item.id}_quantity" do
        expect(page).to have_content '10'
      end
    end

    scenario 'updates revenue' do
      bip_text order_item, :price_cents, '1010'
      within "#best_in_place_order_item_#{order_item.id}_price_cents" do
        expect(page).to have_content '1010'
      end
    end

    scenario 'updates status' do
      bip_select order, :status, 'Заказ выполнен'
      within "#best_in_place_order_#{order.id}_status" do
        expect(page).to have_content 'Заказ выполнен'
      end
    end

    scenario 'updates expense' do
      bip_text order, :expense, '200'
      within "#best_in_place_order_#{order.id}_expense" do
        expect(page).to have_content '200'
      end
    end

    scenario 'cannot update suitable time start' do
      expect(page).to_not have_css("#best_in_place_order_#{order.id}_suitable_time_start")
    end

    scenario 'cannot update suitable time end' do
      expect(page).to_not have_css("#best_in_place_order_#{order.id}_suitable_time_end")
    end

    scenario 'cannot choose manager' do
      expect(page).to_not have_css("#best_in_place_order_#{order.id}_manager_id")
    end

    scenario 'cannot choose master' do
      expect(page).to_not have_css("#best_in_place_order_#{order.id}_master_id")
    end

    scenario 'cannot choose provider' do
      expect(page).to_not have_css("#best_in_place_order_#{order.id}_provider")
    end

    scenario 'cannot update date of order' do
      expect(page).to_not have_css("#best_in_place_order_#{order.id}_date_of_order")
    end
  end
end
