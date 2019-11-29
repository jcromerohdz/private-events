require 'rails_helper'

RSpec.feature "Authentications", type: :feature do
  before :each do
    @user = User.create(name: 'creator', email: 'test@test.com')
  end

  it 'signs me in' do
    visit '/signin'
    fill_in 'session[email]', with: 'test@test.com'
    click_button 'Sign in'
    expect(page).to have_content 'Welcome creator'
  end

  # it 'Sign out' do
  #   visit '/signout'
  #   click_button 'Sign out'
  #   expect(page).to have_content 'Welcome to Eventblitz'
  # end
  
end