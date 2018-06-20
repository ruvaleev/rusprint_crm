require_relative 'acceptance_helper'

feature 'Show questions list', %q{
	In order to find interesting question
	As an user 
	I wanted to see all questions
} do
  
  given(:user_own) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user_own) }

  scenario "User can't see the delete button near the other users questions" do 
    sign_in(another_user)
    visit questions_path
    expect(page).to have_no_text('Delete')
  end

  scenario 'User push the delete button and question is deleting' do      
    sign_in(user_own)
    visit questions_path
    click_on 'Delete'
    expect(page).to have_no_text(question.body) 
  end

  scenario 'Non-authorizied user cannot see the delete button' do      
    visit questions_path
    expect(page).to have_no_text('Delete') 
  end
end