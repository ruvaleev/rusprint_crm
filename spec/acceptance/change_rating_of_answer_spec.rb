require_relative 'acceptance_helper'

feature 'Change rating of Answer', %q{
  In order to rate Answer
  As an authorized User
  I want to be able to change Answer's rating
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question) }
  given(:own_answer) { create(:answer, question: question, user: user) }

  before(:each, authorized: :true) do
    sign_in(user)
    answer
    visit question_path(question)
  end

  scenario 'Authorized user votes for good answer', authorized: :true, js: true do
    click_on 'Plus'
    sleep(1)
    within '.rating' do
      expect(page).to have_text '1'
    end
  end

  scenario 'Authorized user votes against bad answer', authorized: :true, js: true do
    click_on 'Minus'
    sleep(1)
    within '.rating' do
      expect(page).to have_text '-1'
    end
  end

  scenario "Authorized user can't vote for own answer", js: true do
    sign_in(user)
    own_answer
    visit question_path(question)

    expect(page).to_not have_link 'Plus'
    expect(page).to_not have_link 'Minus'
  end

  scenario "Unauthorized user can't vote", js: true do
    answer
    visit question_path(question)

    expect(page).to_not have_link 'Plus'
    expect(page).to_not have_link 'Minus'
  end
end