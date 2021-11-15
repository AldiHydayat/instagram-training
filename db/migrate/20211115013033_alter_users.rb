class AlterUsers < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :is_private, :boolean
  end
end
