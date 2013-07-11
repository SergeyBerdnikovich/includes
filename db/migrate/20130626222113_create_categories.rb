class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :categoryid
     t.integer :account_id
     t.integer :parent_id
      t.string :name
      t.string :description
      t.string :page_title
      t.string :image_file
      t.string :image_tag
      t.string :url
    end
      add_index :images, :categoryid
      add_index :images, :account_id
  end
end
