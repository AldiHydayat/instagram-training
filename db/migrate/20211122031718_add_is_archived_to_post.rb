class AddIsArchivedToPost < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :is_archived, :boolean, :default => false
  end
end
