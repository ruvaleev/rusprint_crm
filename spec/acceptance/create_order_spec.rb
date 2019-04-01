require_relative 'acceptance_helper'

feature 'Create order', '
  In order to create an order in orders table
  As an authentificated user
  I wanted to input orders data
' do

  given(:manager_role) { create(:manager_role) }
  given(:manager) { create(:user, role: manager_role) }
  given!(:customer) { create(:customer) }
  given(:printer_service_guide) { create(:printer_service_guide) }
  given(:printer) { create(:printer, company: customer, printer_service_guide: printer_service_guide) }
  given(:new_printer_service_guide) { create(:printer_service_guide, model: 'new_printer_HP') }
  given(:cartridge) { create(:cartridge_service_guide, printer_service_guide: printer_service_guide) }

  scenario 'Non-authentificated user cannot create order' do
    visit root_path

    expect(page).to_not have_link 'Добавить заказ'
  end

  context 'Authentificated user' do
    before do
      sign_in(manager)
      click_on 'Добавить заказ'
    end

    context 'try create invalid order' do
      scenario 'User see errors when creates empty order' do
        select(customer.name, from: 'order_customer_id')
        click_on 'Создать заказ'

        expect(page).to have_content I18n.t 'orders.errors.order_have_no_shopping_carts'
      end

      scenario 'user see errors when creates order without customer', js: true do
        fill_in 'other_order_item[body]', with: 'Прочие единицы'
        fill_in 'other_order_item[price]', with: '100'
        click_on 'Добавить к заказу'
        sleep(1)
        click_on 'Создать заказ'

        expect(page).to have_content I18n.t 'orders.errors.order_have_no_customer'
      end

      scenario "other order item doesn't creates without body", js: true do
        fill_in 'other_order_item[price]', with: '100'
        click_on 'Добавить к заказу'
        sleep(1)

        expect(find_field('order[revenue]').value).to_not eq '100.00'
      end
    end

    context 'try create valid order' do
      before do
        printer
        cartridge
        select(customer.name, from: 'order_customer_id')
      end
      scenario 'other order item creates with body and price', js: true do
        fill_in 'other_order_item[body]', with: 'Прочие единицы'
        fill_in 'other_order_item[price]', with: '100'
        click_on 'Добавить к заказу'
        sleep(1)

        within '.other_order_items_list' do
          expect(page).to have_content 'Прочие единицы'
        end
        expect(find_field('order[revenue]').value).to eq '100.00'
      end

      scenario "user see customer's printers and cartridges when choosing him", js: true do
        expect(page).to have_content printer_service_guide.model
      end

      scenario "user can add customer's printers to order", js: true do
        within '.customers_printers_list' do
          click_on 'Добавить сам принтер'
        end

        expect(find_field('order[printers]').value).to have_content printer.printer_service_guide.model
      end

      scenario "user can add customer's cartridges to order", js: true do
        within '.customers_printers_list' do
          find("img[alt='Plus']").click
        end
        sleep(1)

        expect(find_field('order[cartridges]').value).to have_content cartridge.model
      end

      scenario "user can remove customer's cartridges from order" # , js: true do
      # НЕ РАБОТАЕТ (JS не отрабатывает)
      #   within '.customers_printers_list' do
      #     find("img[alt='Minus']").click
      #   end
      #   sleep(1)

      #   expect(find_field('order[cartridges]').value).to have_content " - 9 шт"
      # end

      scenario 'user can save and see order after create', js: true do
        find("img[alt='Plus']").click
        sleep(1)
        click_on 'Создать заказ'
        within '#row_1' do
          expect(page).to have_content customer.name
        end
      end

      scenario 'user creates company while creating order', js: true do
        click_on 'new_client_tab'
        within '#second_tab' do
          fill_in 'company[name]', with: 'Новая компания'
          fill_in 'company[adress]', with: 'Адрес компании'
          fill_in 'company[telephone]', with: '89151001010'
        end
        fill_in 'other_order_item[body]', with: 'Прочие единицы'
        fill_in 'other_order_item[price]', with: '100'
        click_on 'Добавить к заказу'
        sleep(1)
        click_on 'Создать заказ'
        sleep(1)
        expect(Company.last.name).to eq 'Новая компания'
      end

      scenario 'user adding printers to customer' # , js: true do
      # НЕ РАБОТАЕТ (JS не отрабатывает)
      #   new_printer_service_guide
      #   click_on 'Добавить принтер'
      #   fill_in 'printer_model_search[model_like]', with: 'new_printer_HP'
      #   click_on 'Найти принтер'
      #   sleep(1)
      #   within '.new_printers_table' do
      #     click_on 'Добавить принтер клиенту'
      #     click_on 'Добавить'
      #   end

      #   expect(Company.last.printers.last.printer_service_guide.model).to_not eq 'new_printer_HP'
      # end
    end
  end
end
