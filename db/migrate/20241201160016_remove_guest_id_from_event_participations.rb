class RemoveGuestIdFromEventParticipations < ActiveRecord::Migration[7.1]
  def change
    remove_column :event_participations, :guest_id, :integer
  end
end
