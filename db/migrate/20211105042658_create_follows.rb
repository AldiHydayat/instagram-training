class CreateFollows < ActiveRecord::Migration[6.0]
  def change
    create_table :follows do |t|
      t.integer :follower_id
      t.integer :following_id
      t.integer :is_approved, default: 0

      t.timestamps
    end
  end
end
