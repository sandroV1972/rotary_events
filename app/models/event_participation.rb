class EventParticipation < ApplicationRecord
  belongs_to :user
  belongs_to :event
  belongs_to :guest, optional: true

  accepts_nested_attributes_for :guest
end