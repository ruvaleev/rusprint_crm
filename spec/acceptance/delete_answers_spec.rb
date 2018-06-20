require_relative 'acceptance_helper'

feature 'Show delete button near answers', %q{
  In order to see question
  As an authentificated user
  I wanted to give answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, question: question, user: user) }
  given!(:another_answer) { create(:another_answer, question: question) }

  scenario "User can't see the delete button near the other users answers" do 
    sign_in(user)
    another_answer
    visit question_path(question)
    expect(page).to have_no_text('Delete')
  end

  scenario 'User uses delete button', js: true do      
    sign_in(user)
    answer
    visit question_path(question)
    click_on 'Delete'
    expect(page).to have_no_text(answer.body) 
  end

  scenario 'Non-authorized user cannot see delete button' do      
    visit question_path(question)
    expect(page).to have_no_text('Delete') 
  end
end