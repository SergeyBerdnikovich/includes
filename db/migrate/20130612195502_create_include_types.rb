class CreateIncludeTypes < ActiveRecord::Migration
  def change
    create_table :include_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
