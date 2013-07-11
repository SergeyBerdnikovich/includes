class CreateStatistics < ActiveRecord::Migration
  def change
    create_table :statistics do |t|
      t.integer :include_id
      t.integer :date
      t.integer :views

      t.timestamps
    end
  end
end
