class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
     t.integer :productid
      t.string :name
      t.string :type
      t.string :sku
      t.string :description
      t.string :availability
      t.string :availability_description
      t.string :price
      t.string :cost_price
      t.string :retail_price
      t.string :sale_price
      t.string :calculated_price
      t.string :inventory_level
      t.string :warranty
      t.string :weight
      t.string :width
      t.string :height
      t.string :depth
      t.string :total_sold
      t.string :date_created
      t.string :brand_id
      t.string :view_count
      t.string :page_title
      t.string :date_modified
      t.string :condition
      t.string :upc
      t.string :custom_url
     t.integer :account_id

    end

      add_index :products, :productid
      add_index :products, :account_id
  end
end
