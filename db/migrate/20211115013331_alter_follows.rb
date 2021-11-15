class AlterFollows < ActiveRecord::Migration[6.0]
  def change
    change_column :follows, :is_approved, :boolean
  end
end
