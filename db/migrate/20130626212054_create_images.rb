class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.integer :imageid
      t.integer :account_id
      t.integer :productid
      t.string :image_file
      t.string :description
    end
      add_index :images, :productid
      add_index :images, :account_id


  end
end
