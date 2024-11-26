class Invitation < ApplicationRecord
  belongs_to :event
  belongs_to :user

  # Stato dell'invito: pending, accepted, declined
  enum status: { pending: 0, accepted: 1, declined: 2 }

  # Genera un token unico per il link di invito
  before_create :generate_token

  def generate_token
    self.token = SecureRandom.hex(10)
  end
end
