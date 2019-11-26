class Event < ApplicationRecord
  belongs_to :user, foreign_key: :creator_id

  validates :name, presence: true
  validates :description, presence: true
  validates :location, presence: true
  validates :time, presence: true


  def creator
    User.find_by(id: self.creator_id).name
  end
end
