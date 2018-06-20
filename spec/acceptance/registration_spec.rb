require_relative 'acceptance_helper'

feature 'registration', %q{
  In order to be able ask questions
  As a new user
  I want be able to make register
 } do

  given(:user) { create(:user) }

  scenario "User uses the button 'Register'" do
    visit root_path
    click_on 'Registration'
    expect(page).to have_content 'Sign up'
  end

  scenario "User registers with valid params" do
    visit root_path
    click_on 'Registration'
    fill_in 'Email', with: 'example@mail.ru'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'
    
    expect(page).to have_content 'Welcome! You have signed up successfully'
  end

  scenario "User registers with invalid password confirmation" do
    visit root_path
    click_on 'Registration'
    fill_in 'Email', with: 'example@mail.ru'
    fill_in 'Password', with: '1234567'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'
    
    expect(page).to have_content "Password confirmation doesn't match Password"
  end

  scenario "User registers with invalid email" do
    visit root_path
    click_on 'Registration'
    fill_in 'Email', with: 'examplemail.ru'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'
    
    expect(page).to have_content "Email is invalid"
  end

  scenario "Registered user doesn't see the register button" do
    sign_in(user)
    expect(page).to have_no_content 'Registration'
  end

end