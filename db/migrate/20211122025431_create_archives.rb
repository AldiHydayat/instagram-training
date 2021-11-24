class CreateArchives < ActiveRecord::Migration[6.0]
  def change
    create_table :archives do |t|
      t.integer :post_id
      t.integer :status

      t.timestamps
    end
  end
end
