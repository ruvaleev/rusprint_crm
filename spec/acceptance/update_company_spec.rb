require_relative 'acceptance_helper'

feature 'Update company', '
  In order to edit a company in orders table
  As an authentificated user
  I wanted to input edited data
' do

  given(:manager_role) { create(:manager_role) }
  given(:master_role) { create(:master_role) }
  given(:manager) { create(:user, role: manager_role) }
  given(:master) { create(:user, role: master_role) }
  given!(:customer) { create(:company) }
  given!(:another_customer) { create(:company, name: 'another customer', adress: 'another customer adress') }
  given!(:order) { create(:order, master: master, manager: manager, customer: customer) }

  context 'Manager or admin', js: true do
    before { sign_in(manager) }

    context "updates company's" do
      scenario 'name' do
        find("#edit_customer_name_in_order_#{order.id}").click
        bip_text order.customer, :name, 'Обновленное название'
        sleep(1)
        within "#company_in_order_#{order.id}" do
          expect(page).to have_content 'Обновленное название'
          order.reload
          expect(order.customer.name).to eq 'Обновленное название'
        end
      end

      scenario 'telephone' do
        find("#edit_customer_telephone_in_order_#{order.id}").click
        bip_text order.customer, :telephone, '89011010102'
        within "#company_in_order_#{order.id}" do
          expect(page).to have_content '89011010102'
          order.reload
          expect(order.customer.telephone).to eq '89011010102'
        end
      end

      scenario 'adress' do
        find("#edit_customer_adress_in_order_#{order.id}").click
        bip_text order.customer, :adress, 'Обновленный адрес'
        within "#company_in_order_#{order.id}" do
          expect(page).to have_content 'Обновленный адрес'
          order.reload
          expect(order.customer.adress).to eq 'Обновленный адрес'
        end
      end
    end

    scenario "changes order's customer" do
      find("#change_customer_#{order.id}").click
      within "#customer_select_#{order.id}" do
        select(another_customer.name, from: 'update_customer')
      end
      within "#company_in_order_#{order.id}" do
        expect(page).to have_content 'another customer adress'
        order.reload
        expect(order.customer.id).to eq another_customer.id
      end
    end

    context "after changing order's customer update company's" do
      before do
        find("#change_customer_#{order.id}").click
        within "#customer_select_#{order.id}" do
          select(another_customer.name, from: 'update_customer')
        end
        sleep(1)
      end

      scenario 'name' do
        find("#edit_customer_name_in_order_#{order.id}").click
        order.reload
        bip_text order.customer, :name, 'Обновленное название'
        within "#company_in_order_#{order.id}" do
          expect(page).to have_content 'Обновленное название'
          order.reload
          expect(order.customer.name).to eq 'Обновленное название'
        end
      end

      scenario 'telephone' do
        find("#edit_customer_telephone_in_order_#{order.id}").click
        order.reload
        bip_text order.customer, :telephone, '89011010102'
        within "#company_in_order_#{order.id}" do
          expect(page).to have_content '89011010102'
          order.reload
          expect(order.customer.telephone).to eq '89011010102'
        end
      end

      scenario 'adress' do
        find("#edit_customer_adress_in_order_#{order.id}").click
        order.reload
        bip_text order.customer, :adress, 'Обновленный адрес'
        within "#company_in_order_#{order.id}" do
          expect(page).to have_content 'Обновленный адрес'
          order.reload
          expect(order.customer.adress).to eq 'Обновленный адрес'
        end
      end
    end
  end

  context 'Master', js: true do
    before { sign_in(master) }

    scenario "updates company's name" do
      find("#edit_customer_name_in_order_#{order.id}").click
      bip_text order.customer, :name, 'Обновленное название'
      within "#company_in_order_#{order.id}" do
        expect(page).to have_content 'Обновленное название'
        order.reload
        expect(order.customer.name).to eq 'Обновленное название'
      end
    end

    scenario "updates company's telephone" do
      find("#edit_customer_telephone_in_order_#{order.id}").click
      bip_text order.customer, :telephone, '89011010102'
      within "#company_in_order_#{order.id}" do
        expect(page).to have_content '89011010102'
        order.reload
        expect(order.customer.telephone).to eq '89011010102'
      end
    end

    scenario "updates company's adress" do
      find("#edit_customer_adress_in_order_#{order.id}").click
      bip_text order.customer, :adress, 'Обновленный адрес'
      within "#company_in_order_#{order.id}" do
        expect(page).to have_content 'Обновленный адрес'
        order.reload
        expect(order.customer.adress).to eq 'Обновленный адрес'
      end
    end

    scenario "cannot change order's customer" do
      expect(page).to_not have_css "#change_customer_#{order.id}"
    end
  end
end
