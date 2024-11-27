class Event < ApplicationRecord
  has_many :invitations
  has_many :event_participations
  has_many :invited_users, through: :invitations, source: :user
  belongs_to :event_type, optional: true

  validates :name, :description, :date, presence: true
end