class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.integer :includes
      t.integer :impressions
      t.boolean :api_shortcodes
      t.boolean :html_uploads
      t.boolean :advanced_logic
      t.string :support
      t.float :price

      t.timestamps
    end
  end
end
