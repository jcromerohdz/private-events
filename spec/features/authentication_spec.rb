# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Authentications', type: :feature do
  before :each do
    @user = User.create(name: 'creator', email: 'test@test.com')
  end

  it 'Sign In' do
    visit '/signin'
    fill_in 'session[email]', with: 'test@test.com'
    click_button 'Sign in'
    expect(page).to have_content 'Welcome creator'
  end

  it 'Sign Out' do
    visit '/signin'
    fill_in 'session[email]', with: 'test@test.com'
    click_button 'Sign in'
    click_on 'Log Out'
    expect(page).to have_content 'Welcome to Eventblitz'
  end
end
