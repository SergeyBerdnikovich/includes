class CreateCategoryProducts < ActiveRecord::Migration
  def change
    create_table :category_products do |t|
      t.integer :account_id
      t.integer :productid
      t.integer :categoryid

      t.timestamps
    end
  end
end
