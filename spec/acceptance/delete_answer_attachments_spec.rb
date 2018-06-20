require_relative 'acceptance_helper'

feature 'Delete answer attachments', %q{
  In order to edit my answer
  As an answers author
  I want to be able to delete attachments
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:my_answer) { create(:answer, question: question, user: user) }
  given(:not_my_answer) { create(:answer, question: question) }
  given(:my_attachment) { create(:attachment, attachable: my_answer) }
  given(:not_my_attachment) { create(:attachment, attachable: not_my_answer) }


  scenario "Answer's author can delete an attachment" do
    my_answer
    my_attachment
    sign_in(user) 
    visit question_path(question)
    click_on 'Cancel'

    expect(page).to_not have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end

  scenario "User try to delete another user's answer's attachment" do
    not_my_answer
    not_my_attachment
    sign_in(user) 
    visit question_path(question)

    expect(page).to_not have_link 'Cancel'
  end

end