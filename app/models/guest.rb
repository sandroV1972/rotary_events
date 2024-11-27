class Guest < ApplicationRecord
  belongs_to :user
  belongs_to :event_participation, optional: true

  validates :name, :surname, presence: true
end