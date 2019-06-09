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
  given!(:printer) { create(:printer, company: customer, printer_service_guide: printer_service_guide) }
  given(:new_printer_service_guide) { create(:printer_service_guide, model: 'new_printer_HP') }
  given!(:cartridge) { create(:cartridge_service_guide, printer_service_guide: printer_service_guide) }

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

      scenario 'see errors when creates order without customer', js: true, retry: 5 do
        select(customer.name, from: 'order_customer_id')
        within '#new_order .customer' do
          find("img[alt='Plus']").click
        end
        select('Выберите клиента', from: 'order_customer_id')
        sleep(1)
        click_on 'Создать заказ'

        expect(page).to have_content I18n.t 'orders.errors.order_have_no_customer'
      end

      scenario "can't create other order item without body", js: true do
        select(customer.name, from: 'order_customer_id')
        loop do
          within '#new_order .customer' do
            find("img[alt='Plus']").click
          end
          wait_for_ajax
          break if ShoppingCart.last.try(:id)
        end
        shopping_cart_id = ShoppingCart.last.try(:id)
        within '.shopping_cart_for_new_order' do
          page.execute_script %($("#show_new_other_item_modal_#{shopping_cart_id}").click())

          within "#new_other_order_item_form_for_shopping_cart_#{shopping_cart_id}" do
            fill_in 'other_order_item[price]', with: '100'

            expect(page).to have_css('#add_other_order_item.disabled')
            expect(page).to have_css('#other_order_item_body.error_required_field')
          end
        end
      end

      scenario "can't create other order item without price", js: true do
        select(customer.name, from: 'order_customer_id')
        within '#new_order .customer' do
          find("img[alt='Plus']").click
          sleep(1)
        end
        shopping_cart_id = ShoppingCart.last.try(:id)
        within '.shopping_cart_for_new_order' do
          find("#show_new_other_item_modal_#{shopping_cart_id}").click
        end
        within "#new_other_order_item_form_for_shopping_cart_#{shopping_cart_id}" do
          fill_in 'other_order_item[body]', with: 'other order item body'

          expect(page).to have_css('#add_other_order_item.disabled')
          expect(page).to have_css('#other_order_item_price.error_required_field')
        end
      end
    end

    context 'try create valid order' do
      before do
        printer
        cartridge
        select(customer.name, from: 'order_customer_id')
      end

      scenario 'other order item creates with body and price', js: true, retry: 5 do
        within '#new_order .customer' do
          find("img[alt='Plus']").click
          sleep(1)
        end
        shopping_cart_id = ShoppingCart.last.try(:id)
        within '.shopping_cart_for_new_order' do
          find("#show_new_other_item_modal_#{shopping_cart_id}").click
        end
        within "#new_other_order_item_form_for_shopping_cart_#{shopping_cart_id}" do
          fill_in 'other_order_item[body]', with: 'other order item body'
          fill_in 'other_order_item[price]', with: '100'
          click_on 'Добавить к заказу'
          sleep(1)
        end

        within '.shopping_cart_for_new_order' do
          expect(page).to have_content '100.00 руб.'
        end
      end

      scenario "user see customer's printers and cartridges when choosing him", js: true do
        expect(page).to have_content printer_service_guide.model
      end

      xscenario "user can add customer's printers to order", js: true do
        # Пока отключили такую возможность
        within '.customers_printers_list' do
          click_on 'Добавить сам принтер'
        end

        expect(find_field('order[printers]').value).to have_content printer.printer_service_guide.model
      end

      scenario "user can add customer's cartridges to order", js: true do
        within '#new_order .customer' do
          find("img[alt='Plus']").click
        end
        wait_for_ajax
        within '.shopping_cart_for_new_order' do
          expect(page).to have_content cartridge.model
        end
      end

      scenario "user can remove customer's cartridges from order", js: true do
        within '#new_order .customer' do
          fill_in "qnt_field_#{cartridge.id}_for_", with: '10'
          find("img[alt='Plus']").click
        end
        wait_for_ajax
        order_item_id = OrderItem.last.try(:id)
        within '.shopping_cart_for_new_order' do
          find("#destroy_order_item_#{order_item_id}").click
          wait_for_ajax

          expect(page).to_not have_content cartridge.model
        end
      end

      scenario 'user can save and see order after create', js: true, retry: 7 do
        find("img[alt='Plus']").click
        sleep(1)
        click_on 'Создать заказ'
        sleep(1)
        within "#row_#{Order.last.id}" do
          expect(page).to have_content(customer.name, wait: 1.0)
        end
      end

      scenario 'user creates company while creating order', js: true do
        click_on 'Добавить нового клиента'
        within '#new_company_form' do
          fill_in 'company[name]', with: 'Новая компания'
          fill_in 'company[adress]', with: 'Адрес компании'
          fill_in 'company[telephone]', with: '89151001010'
          click_on 'Внести в каталог'
        end
        sleep(1)
        expect(Company.last.name).to eq 'Новая компания'
      end

      scenario 'user adding printers to customer', js: true do
        new_printer_service_guide
        select(customer.name, from: 'order_customer_id')
        click_on 'Добавить принтер'
        within '#new_printer_modal' do
          fill_in 'printer_model_search[model_like]', with: 'new_printer_HP'
          # Костыль, который позволяет обойти баг капибары
          page.execute_script %($('form#search_printer_form_for_company__sc_').submit())
          within '#add_new_printer_table' do
            page.execute_script %($('input[value="Добавить принтер клиенту"]').click())
            page.execute_script %($('input[value="Добавить"]').click())
            sleep(1)
          end
        end

        expect(Company.last.printers.count).to eq 2
        expect(Company.last.printers.last.printer_service_guide.model).to eq 'new_printer_HP'
      end
    end
  end
end
