require_relative 'acceptance_helper'

feature 'Show questions list', %q{
	In order to find interesting question
	As an user 
	I wanted to see all questions
} do
  
  given(:user_own) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user_own) }
  given(:another_question) { create(:another_question) }

  scenario 'User see the all questions list as a table' do      
    question
    another_question
    visit questions_path
    expect(page).to have_text(question.body)
    expect(page).to have_text(another_question.body) 
  end

  scenario 'User see the title "Questions list" on the page' do      
    visit questions_path
    expect(page).to have_text('Questions list') 
  end

end