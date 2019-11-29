# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'All credetial are provided' do
    it 'should have creator' do
      user = User.create(name: 'test', email: 'test@test.com')
      event = user.events.build(name: 'Comic con', location: 'texas', description: 'event description', time: '2019-12-26', creator_id: user.id)
      event.valid?
      expect(event).to be_valid
    end
  end

  describe 'no date provided' do
    it 'is not valid ' do
      user = User.create(name: 'test', email: 'test@test.com')
      event = Event.new(name: 'Comic con', location: 'texas', description: 'event description', time: nil, creator_id: user.id)
      expect(event.valid?).to be false
    end
  end

  describe 'no creator id provided' do
    it 'is not valid' do
      user = User.create(name: 'test', email: 'test@test.com')
      event = Event.new(name: 'Comic con', location: 'texas', description: 'event description', time: '2019-12-26', creator_id: nil)
      expect(event.valid?).to be false
    end
  end

  context 'no description provided' do
    it 'is not valid' do
      user = User.create(name: 'test', email: 'test@test.com')
      event = Event.new(name: 'Comic con', location: nil, description: 'event description', time: '2019-12-26', creator_id: user.id)
      expect(event.valid?).to be false
    end
  end
end
