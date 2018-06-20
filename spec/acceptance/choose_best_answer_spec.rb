require_relative 'acceptance_helper'

feature 'Choose best answer spec', %q{
  In order to see best answer
  As an questions author
  I want to choose best answer
} do
  given(:user) { create(:user) }
  given(:own_question) { create(:question, user: user) }
  given(:another_users_question) { create(:question) }
  given!(:best_answer) { create(:another_answer, question: own_question) }
  given!(:answer) { create(:answer, question: own_question) }
  given(:answers_for_another_question) { create_list(:answer, 4, question: another_users_question) }

  scenario 'Non-authentificated user try to choose best answer' do
    visit question_path(another_users_question)

    expect(page).to_not have_link('It is best!')
  end

  describe 'Authenticated user trying choose best answer' do
    before { sign_in(user) }
    
    scenario 'for own question', js: true do
      visit question_path(own_question)
      click_on('It is best!', match: :first)
      within '#best' do
        expect(page).to have_content(best_answer.body)
      end
    end


    scenario "for another user's question" do
      answers_for_another_question
      visit question_path(another_users_question)

      expect(page).to_not have_link('It is best!')
    end
  end 
end