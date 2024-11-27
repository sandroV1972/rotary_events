class AddEventParticipationIdToGuests < ActiveRecord::Migration[6.1]
  def change
    add_column :guests, :event_participation_id, :integer
    add_index :guests, :event_participation_id
  end
end
