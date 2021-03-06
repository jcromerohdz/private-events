# frozen_string_literal: true

class Event < ApplicationRecord
  belongs_to :user, foreign_key: :creator_id
  has_many :people_attending, foreign_key: 'attended_event_id',
                              class_name: 'Attendance'
  has_many :attendees, through: :people_attending

  scope :upcoming, -> { where('time >= ?', Time.zone.now) }
  scope :past, -> { where('time < ?', Time.zone.now) }

  validates :name, presence: true
  validates :description, presence: true
  validates :location, presence: true
  validates :time, presence: true

  def creator
    User.find_by(id: creator_id).name
  end
end
