class AddReplyIdToComments < ActiveRecord::Migration[6.0]
  def change
    add_column :comments, :reply_id, :integer
  end
end
