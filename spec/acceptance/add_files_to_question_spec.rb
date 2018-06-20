require_relative 'acceptance_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an questions author
  I want to be able to attach files
} do

  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
    fill_in 'Title', with: 'title'
    fill_in 'Body', with: 'body'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
  end

  scenario 'User adds file when asks question' do
    click_on 'Create'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end

  scenario 'User adds few files when asks question', js: true do
    click_on 'add file'
    attach_file 'File', "#{Rails.root}/spec/rails_helper.rb", match: :first
    click_on 'Create'

    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/3/spec_helper.rb'
  end

  scenario 'User deletes file when asks question' do
    click_on 'remove file'

    expect(page).to_not have_link 'spec_helper.rb', href: '/uploads/attachment/file/4/spec_helper.rb'
  end

end