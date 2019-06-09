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
  given!(:company) { create(:company) }
  given!(:order) { create(:order, master: master, manager: manager, customer: company) }
  given!(:printer_service_guide) { create(:printer_service_guide) }
  given!(:printer) { create(:printer, printer_service_guide: printer_service_guide) }
  given!(:cartridge) { create(:cartridge_service_guide, printer_service_guide: printer_service_guide) }
  given!(:order_item) { create(:order_item, order: order, item: cartridge, owner: order.shopping_cart) }

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

    context 'through modal window function' do
      given!(:printer_service_guide) { create(:printer_service_guide) }
      given!(:printer) { create(:printer, printer_service_guide: printer_service_guide, company: company) }
      given!(:cartridge_service_guide) do
        create(:cartridge_service_guide, printer_service_guide: printer_service_guide)
      end
      given!(:another_printer_service_guide) { create(:printer_service_guide) }
      given!(:another_cartridge_service_guide) do
        create(:cartridge_service_guide, printer_service_guide: another_printer_service_guide)
      end

      before { find("#show_new_cartridge_modal_#{order.shopping_cart_id}").click }

      scenario 'adds new printer to company', retry: 7 do
        within "#new_cartridge_modal_#{order.id}" do
          fill_in 'printer_model_search[model_like]', with: another_printer_service_guide.model
          click_on 'Найти принтер'
          page.execute_script %($('input[value="Добавить принтер клиенту"]').click())
          page.execute_script %($('input[value="Добавить"]').click())
          wait_for_ajax
          within '.customers_printers_list' do
            expect(page).to have_content another_printer_service_guide.model
          end
        end
      end

      scenario 'see modal adding new cartridge to order' do
        expect(page).to have_content 'Добавить картридж'
      end

      scenario 'see printer and cartridges in modal' do
        expect(page).to have_content printer.printer_service_guide.model
        expect(page).to have_content cartridge_service_guide.model
      end

      scenario 'adds new cartridge to order' do
        find("#plus_#{cartridge_service_guide.id}_for_#{order.shopping_cart_id || ''}").click
        wait_for_ajax
        expect(page).to_not have_selector("#new_cartridge_modal_#{order.id}", visible: true)

        within "#shopping_cart_cell_#{order.shopping_cart_id}" do
          expect(page).to have_content printer.printer_service_guide.model
          expect(page).to have_content cartridge_service_guide.model
        end
      end

      xscenario 'adds new cartridge of new printer to order', retry: 7 do
        within  "#new_cartridge_modal_#{order.id}" do
          fill_in 'printer_model_search[model_like]', with: another_printer_service_guide.model
          click_on 'Найти принтер'
          click_on 'Добавить принтер клиенту'
          click_on 'Добавить'
          wait_for_ajax
          sleep(1)
          within '.customers_printers_list' do
            find("#plus_#{another_cartridge_service_guide.id}_for_#{order.shopping_cart_id}").click
            sleep(1)
            expect(page).to have_selector("#new_cartridge_modal_#{order.id}")

            within "#order_items_in_order_#{order.id}" do
              expect(page).to_not have_content another_printer_service_guide.model
              expect(page).to_not have_content another_service_guide.model
            end
          end
        end
      end

      scenario 'updates order item cell'
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
