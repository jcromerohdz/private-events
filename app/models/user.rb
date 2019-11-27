class User < ApplicationRecord
  has_many :events, foreign_key: :creator_id
  has_many :attended, foreign_key: 'attendee_id', class_name: 'Attendance'
  has_many :attended_events, through: :attended
	before_save { self.email = email.downcase }
  validates :name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }, 
                    uniqueness: { case_sensitive: false }

end