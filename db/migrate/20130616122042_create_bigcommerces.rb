class CreateBigcommerces < ActiveRecord::Migration
  def change
    create_table :bigcommerces do |t|
      t.string :store_url
      t.string :username
      t.string :api_key

      t.timestamps
    end
  end
end
