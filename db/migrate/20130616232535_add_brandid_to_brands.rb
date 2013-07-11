class AddBrandidToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :brandid, :integer
  end
end
