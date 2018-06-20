require_relative 'acceptance_helper'

feature 'Answer editing', %q{
  In order to fix mistake
  As an author of Answer
  I'd like to be able to edit my Answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:another_answer) { create(:another_answer, question: question) }
  given(:answer) { create(:answer, question: question, user: user) }
  
  scenario 'Unauthorized user try to edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    before { sign_in(user) }
    before(:each, answer: :own) do 
      answer    
      visit question_path(question)
      click_on 'Edit'
    end

    describe 'try to edit his answer'

      scenario 'and see own edition', answer: :own, js: true do
        within '.answers' do
          fill_in 'answer[body]', with: "I've edit my answer"
          click_on 'Save'

          expect(page).to have_content "I've edit my answer"
        end
      end

      scenario 'and not see old answer', answer: :own, js: true do
        within '.answers' do
          fill_in 'answer[body]', with: "I've edit my answer"
          click_on 'Save'

          expect(page).to_not have_content answer.body
        end
      end

      scenario 'and not see textarea for editing', answer: :own, js: true do
        within '.answers' do
          fill_in 'answer[body]', with: "I've edit my answer"
          click_on 'Save'

          expect(page).to_not have_selector 'textarea'
        end
      end

    scenario "try to edit other user's answer" do
      another_answer
      visit question_path(question)
      within '.answers' do
        expect(page).to_not have_link 'Edit'
      end
    end

  end
end