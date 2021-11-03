class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.string :file_post
      t.text :caption

      t.timestamps
    end
  end
end
