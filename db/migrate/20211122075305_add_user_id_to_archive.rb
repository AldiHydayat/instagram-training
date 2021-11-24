class AddUserIdToArchive < ActiveRecord::Migration[6.0]
  def change
    add_column :archives, :user_id, :integer
  end
end
