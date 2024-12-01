class EventParticipation < ApplicationRecord
  belongs_to :user
  belongs_to :event
  has_many :guests, dependent: :destroy
  accepts_nested_attributes_for :guests, allow_destroy: true
end