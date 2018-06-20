require_relative 'acceptance_helper'

feature 'Authorizing through facebook', %q{
  In order to authorize
  As a new user
  I want to be able to do it through a facebook account
} do

  given(:user) { create(:user) }
  given(:twitter_authorization) { create(:authorization, user: user, provider: 'facebook', uid: '123545') }

  background do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      :provider => 'facebook',
      :uid => '123545',
      :info => { some_parameter: true }
    })
  end

  scenario 'New user signs in through facebook' do
    visit questions_path
    click_on 'Sign_in'
    click_on 'Sign in with Facebook'

    expect(page).to have_text 'We strongly recommend to change your email and confirm it'
  end

  scenario 'Existing user signs in through facebook' do
    user
    twitter_authorization
    visit questions_path
    click_on 'Sign_in'
    click_on 'Sign in with Facebook'

    expect(page).to have_text 'Successfully authenticated from facebook account.'
  end

end