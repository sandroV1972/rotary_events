class RemoveNumberOfGuestsFromEventParticipations < ActiveRecord::Migration[6.1]
  def change
    remove_column :event_participations, :number_of_guests, :integer
  end
end