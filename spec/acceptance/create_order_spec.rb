require_relative 'acceptance_helper'

feature 'Create order', %q{
  In order to input new order to orders table
  As an authentificated user
  I wanted to 
} do

  given(:manager_role) { create(:manager_role) }
  given(:manager) { create(:user, role: manager_role) }

  scenario 'Authentificated user creates question' 

  # scenario 'Non-authentificated user creates question'# do
    # visit questions_path

    # expect(page).to_not have_link 'Ask question'
  #end

  # scenario 'Authentificated user see errors when creates invalid question' #do
    # sign_in(user)
    # visit questions_path
    # click_on 'Ask question'
    # click_on 'Create'
    
    # expect(page).to have_content 'prohibited this object from being saved'
    # expect(page).to have_content "Title can't be blank"
    # expect(page).to have_content "Body can't be blank"
  #end  

  # context 'multiple sessions' #do
    # scenario "quesiton appears on another user's page", js: true do
    #   Capybara.using_session('user') do
    #     sign_in(user)
    #     visit questions_path
    #   end

    #   Capybara.using_session('guest') do
    #     visit questions_path
    #   end

    #   Capybara.using_session('user') do
    #     click_on 'Ask question'
    #     fill_in 'Title', with: 'test title'
    #     fill_in 'Body', with: 'test body'
    #     click_on 'Create'

    #     expect(page).to have_content 'test title'
    #     expect(page).to have_content 'test body'
    #     expect(page).to have_content 'Your question successfully created'
    #   end

    #   Capybara.using_session('guest') do
    #     expect(page).to have_content 'test title'
    #     expect(page).to have_content 'test body'
    #   end

    # end
 # end
  
end