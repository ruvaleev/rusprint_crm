require_relative 'acceptance_helper'

feature 'Create comment', %q{
  In order to comment an answer
  As an authentificated user
  I wanted to make a comment
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  scenario 'Authentificated user creates comment', js: true do
    sign_in(user)
    visit question_path(question)
    click_on 'Comment'
    fill_in 'comment[body]', :with => 'Test comment. Much of text'
    click_on 'Save'
    sleep(1)

    expect(page).to have_text('Test comment. Much of text')
  end

  scenario "Non-authentificated user can't create comment" do
    visit question_path(question)

    expect(page).to_not have_button 'Comment'
  end

  context 'multiple sessions' do
    scenario "answer appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        click_on 'Comment'
        fill_in 'comment[body]', :with => 'Test comment. Much of text'
        click_on 'Save'
        sleep(1)

        expect(page).to have_text('Test comment. Much of text')
      end

      Capybara.using_session('guest') do
        expect(page).to have_text('Test comment. Much of text')
      end

    end
  end
  
end