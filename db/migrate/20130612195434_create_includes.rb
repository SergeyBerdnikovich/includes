class CreateIncludes < ActiveRecord::Migration
  def change
    create_table :includes do |t|
      t.string :name
      t.text :content
      t.integer :brand_id
      t.integer :include_type_id

      t.timestamps
    end
  end
end
