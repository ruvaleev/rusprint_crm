require_relative 'acceptance_helper'

feature 'Signing in', %q{
  In order to be able ask questions
  As an user
  I want be able to sign in
 } do

  given(:user) { create(:user) }

  scenario "Existing user try to sign in" do
    sign_in(user)
    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'Non-existing user try to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: 'wrong@user.com'
    fill_in 'Password', with: '12345'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password'
  end

  scenario "User uses the button 'Sign in'" do
    visit root_path
    click_on 'Sign_in'
    expect(page).to have_content 'Log in'
  end

  scenario "Authentificated user try to sign out" do
    sign_in(user)
    click_on 'Sign_out'
    expect(page).to have_content 'Signed out successfully.'
  end


end