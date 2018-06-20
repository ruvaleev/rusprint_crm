require_relative 'acceptance_helper'

feature 'Authorizing through twitter', %q{
  In order to authorize
  As a new user
  I want to be able to do it through a twitter account
} do

  given(:user) { create(:user) }
  given(:twitter_authorization) { create(:authorization, user: user, provider: 'twitter', uid: '123545') }

  background do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
      :provider => 'twitter',
      :uid => '123545',
      :info => { some_parameter: true }
    })
  end

  scenario 'New user signs in through twitter' do
    visit questions_path
    click_on 'Sign_in'
    click_on 'Sign in with Twitter'

    expect(page).to have_text 'We strongly recommend to change your email and confirm it'
  end

  scenario 'Existing user signs in through twitter' do
    user
    twitter_authorization
    visit questions_path
    click_on 'Sign_in'
    click_on 'Sign in with Twitter'

    expect(page).to have_text 'Successfully authenticated from twitter account.'
  end

end