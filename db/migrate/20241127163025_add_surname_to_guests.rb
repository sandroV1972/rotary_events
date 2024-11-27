class AddSurnameToGuests < ActiveRecord::Migration[6.1]
  def change
    add_column :guests, :surname, :string
  end
end
