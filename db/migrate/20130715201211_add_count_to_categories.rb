class AddCountToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :product_count, :integer
  end
end
