class Guest < ApplicationRecord
  belongs_to :event_participation
  belongs_to :user, optional: true

  validates :name, presence: true
  validates :surname, presence: true
end