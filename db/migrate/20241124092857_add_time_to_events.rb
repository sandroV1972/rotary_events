class AddTimeToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :time, :datetime
  end
end
