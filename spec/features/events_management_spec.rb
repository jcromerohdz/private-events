# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'EventsManagements', type: :feature do
  before :each do
    @user = User.create(name: 'creator', email: 'test@test.com')
  end

  it 'Event Creation' do
    visit '/signin'
    fill_in 'session[email]', with: 'test@test.com'
    click_button 'Sign in'
    expect(page).to have_content 'Welcome creator'
    visit root_path
    expect(page).to have_content 'Welcome to Eventblitz'
    click_link 'Create an event'
    expect(page).to have_content 'Create Event'
    fill_in 'event[name]', with: 'Test'
    fill_in 'event[location]', with: 'germ'
    fill_in 'event[description]', with: ' some weird convention'
    fill_in 'event[time]', with: '2019-12-26'
    click_button 'Create Event'
    expect(page).to have_content 'Test'
  end

  it 'Attending functionality' do
    visit '/signin'
    fill_in 'session[email]', with: 'test@test.com'
    click_button 'Sign in'
    expect(page).to have_content 'Welcome creator'
    visit root_path
    expect(page).to have_content 'Welcome to Eventblitz'
    click_link 'Create an event'
    expect(page).to have_content 'Create Event'
    fill_in 'event[name]', with: 'Test'
    fill_in 'event[location]', with: 'germ'
    fill_in 'event[description]', with: ' some weird convention'
    fill_in 'event[time]', with: '2019-12-26'
    click_button 'Create Event'
    expect(page).to have_content 'Test'
    click_link 'Attend to event'
    page.find('ol', text: 'creator')
  end

  it 'Attending functionality' do
    visit '/signin'
    fill_in 'session[email]', with: 'test@test.com'
    click_button 'Sign in'
    expect(page).to have_content 'Welcome creator'
    visit root_path
    expect(page).to have_content 'Welcome to Eventblitz'
    click_link 'Create an event'
    expect(page).to have_content 'Create Event'
    fill_in 'event[name]', with: 'Test'
    fill_in 'event[location]', with: 'germ'
    fill_in 'event[description]', with: ' some weird convention'
    fill_in 'event[time]', with: '2019-12-26'
    click_button 'Create Event'
    expect(page).to have_content 'Test'
    click_link 'Attend to event'
    page.find('ol', text: 'creator')
  end

  it 'Not attending functionality' do
    visit '/signin'
    fill_in 'session[email]', with: 'test@test.com'
    click_button 'Sign in'
    expect(page).to have_content 'Welcome creator'
    visit root_path
    expect(page).to have_content 'Welcome to Eventblitz'
    click_link 'Create an event'
    expect(page).to have_content 'Create Event'
    fill_in 'event[name]', with: 'Test'
    fill_in 'event[location]', with: 'germ'
    fill_in 'event[description]', with: ' some weird convention'
    fill_in 'event[time]', with: '2019-12-26'
    click_button 'Create Event'
    expect(page).to have_content 'Test'
    click_link 'Attend to event'
    page.find('ol', text: 'creator')
    click_link 'Not going anymore'
    expect(page).to have_content 'No attendees for this event yet'
  end
end
