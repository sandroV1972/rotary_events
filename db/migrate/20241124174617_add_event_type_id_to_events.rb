class AddEventTypeIdToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :event_type_id, :integer
  end
end
