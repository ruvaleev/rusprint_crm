require_relative 'acceptance_helper'

feature 'Change email', %q{
  In order to use real email
  As a new user
  I want to be able to change temporary email
} do

  given(:user) { create(:user) }

  scenario 'User setting new email' do
    sign_in(user)
    visit set_email_user_path(user)
    fill_in 'user[email]', :with => 'new_custom_made_email@test.com'
    click_on 'Update'

    expect(page).to have_text "Hello, new_custom_made_email@test.com"
  end


end