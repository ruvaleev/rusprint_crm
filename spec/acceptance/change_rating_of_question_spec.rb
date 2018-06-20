require_relative 'acceptance_helper'

feature 'Change rating of Quesiton', %q{
  In order to rate Questions
  As an authorized User
  I want to be able to change Question's rating
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:own_question) { create(:question, user: user) }

  before(:each, authorized: :true) do
    question
    sign_in(user)
  end

  scenario 'Authorized user votes for good question', authorized: :true, js: true do
    click_on 'Plus'
    sleep(1)
    within '.rating' do
      expect(page).to have_text '1'
    end
  end

  scenario 'Authorized user votes against bad question', authorized: :true, js: true do
    click_on 'Minus'
    sleep(1)
    within '.rating' do
      expect(page).to have_text '-1'
    end
  end

  scenario "Authorized user can't vote for own question", js: true do
    sign_in(user)
    own_question
    expect(page).to_not have_link 'Plus'
    expect(page).to_not have_link 'Minus'
  end

  scenario "Unauthorized user can't vote", js: true do
    question
    expect(page).to_not have_link 'Plus'
    expect(page).to_not have_link 'Minus'
  end
end