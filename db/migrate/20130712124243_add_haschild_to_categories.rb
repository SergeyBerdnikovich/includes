class AddHaschildToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :has_child, :boolean
  end
end
