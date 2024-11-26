class UpdateEmailConstraintsInUsers < ActiveRecord::Migration[6.1]
  def change
    # Ensure the email is not null
    change_column_null :users, :email, false
    
    # Ensure the email is unique
    add_index :users, :email, unique: true unless index_exists?(:users, :email)
  end
end
