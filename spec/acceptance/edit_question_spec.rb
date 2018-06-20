require_relative 'acceptance_helper'

feature 'Question editing', %q{
  In order to fix mistake
  As an author of Question
  I'd like to be able to edit my Question
} do

  given(:user) { create(:user) }
  given(:own_question) { create(:question, user: user) }
  given(:another_question) { create(:another_question) }
  
  scenario 'Unauthorized user try to edit question' do
    visit questions_path

    expect(page).to_not have_link 'Edit'
  end


  describe 'Authenticated user' 
    before { sign_in(user) }

    describe 'try to edit his question'
    
      scenario 'and see his editions', js: true do
        own_question
        visit questions_path
        click_on 'Edit'
        within '.questions' do
          fill_in 'question[body]', with: "I've edit my question"
          click_on 'Save'

          expect(page).to have_content "I've edit my question"
        end
      end

      scenario 'and dont see his old question', js: true do
        own_question
        visit questions_path
        click_on 'Edit'
        within '.questions' do
          fill_in 'question[title]', with: "Edited question"
          click_on 'Save'

          expect(page).to_not have_content own_question.title
        end
      end

    scenario "try to edit other user's question" do
      another_question
      visit questions_path

      expect(page).to_not have_link 'Edit'
    end
  
end