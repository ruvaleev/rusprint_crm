require_relative 'acceptance_helper'

feature 'Delete question attachments', %q{
  In order to edit my question
  As an questions author
  I want to be able to delete attachments
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:another_question) { create(:question) }
  given!(:attachment) { create(:attachment, attachable: question) }

  background { sign_in(user) }

  scenario "Question's author can delete an attachment" do
    visit question_path(question)
    click_on 'delete file'

    expect(page).to_not have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'

  end 

  scenario "User try to delete another user's question's attachment" do
    visit question_path(another_question)

    expect(page).to_not have_link 'delete file'

  end 

end