# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  before :each do
    User.create(name: 'test', email: 'test@test.com')
  end
  describe '#name' do
    before :each do
      User.create(name: 'test', email: 'test@test.com')
    end
    it 'doesnt take user without the name' do
      user = User.new
      user.name = nil
      user.valid?
      expect(user.errors[:name]).to include("can't be blank")

      user.name = 'test'
      user.valid?
      expect(user.errors[:name]).to_not include("can't be blank")
    end
  end

  describe '#email' do
    it 'validates for presence of email adress' do
      user = User.new
      user.name = 'test3334'
      user.email = ''
      user.valid?
      expect(user.errors[:email]).to include('is invalid')

      user.email = 'test3334@gmail.com'
      user.valid?
      expect(user.errors[:email]).to_not include('is invalid')
    end

    it 'validates for format of email adress' do
      user = User.new
      user.name = 'test3334'
      user.email = 'test@test..com'
      user.valid?
      expect(user.errors[:email]).to include('is invalid')

      user.email = 'test3334@gmail.com'
      user.valid?
      expect(user.errors[:email]).to_not include('is invalid')
    end
  end

  describe '#attended_events' do
    it 'should be able to list attendees' do
      creator = User.create(name: 'creator', email: 'creator@email.com')
      attendee = User.create(name: 'attendee', email: 'attendee@email.com')
      event = Event.create(name: 'Comic con', location: 'texas', description: 'event description', time: '2019-12-26', creator_id: creator.id)
      event.attendees << attendee
      expect(User.last.attended_events.first).to eql(event)
    end
  end

  describe '#events' do
    it 'should be able to list attendees' do
      creator = User.create(name: 'creator', email: 'creator@email.com')
      attendee = User.create(name: 'attendee', email: 'attendee@email.com')
      event = Event.create(name: 'Comic con', location: 'texas', description: 'event description', time: '2020-08-26', creator_id: creator.id)
      event.attendees << attendee
      expect(User.find_by_email('creator@email.com').events.first).to eql(event)
    end
  end
end
