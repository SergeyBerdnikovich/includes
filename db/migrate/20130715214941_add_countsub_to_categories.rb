class AddCountsubToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :product_sub_count, :integer
  end
end
