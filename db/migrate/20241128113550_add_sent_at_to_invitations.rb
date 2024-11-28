class AddSentAtToInvitations < ActiveRecord::Migration[7.1]
  def change
    add_column :invitations, :sent_at, :datetime
  end
end
