require_relative 'acceptance_helper'

feature 'Show question and answers', %q{
	In order to see question
	As an authentificated user
	I wanted to give answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, question: question, user: user) }
  given(:another_answer) { create(:another_answer, question: question) }

  scenario 'User see the question and its title' do      
    visit question_path(question)
    expect(page).to have_text(question.body) 
    expect(page).to have_text(question.title)
  end

  scenario 'User see the answers for the question' do
    answer
    another_answer
    visit question_path(question)
    expect(page).to have_text(answer.body)
    expect(page).to have_text(another_answer.body)
  end

end