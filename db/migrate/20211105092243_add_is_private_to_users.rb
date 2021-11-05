class AddIsPrivateToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :is_private, :integer, default: 0
  end
end
