class CreateIncludeOptions < ActiveRecord::Migration
  def change
    create_table :include_options do |t|
      t.integer :include_id
      t.integer :option_id
      t.string :value

      t.timestamps
    end
  end
end
