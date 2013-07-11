class AddFieldsToBrands < ActiveRecord::Migration
  def change
  	add_column :brands, :page_title, :string
    add_column :brands, :meta_keywords, :string
    add_column :brands, :meta_description, :string
    add_column :brands, :image_file, :string
    add_column :brands, :search_keywords, :string
  end
end
