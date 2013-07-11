class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.integer :date
      t.string :alert_type
      t.text :des
      t.boolean :processed
      t.integer :account_id

      t.timestamps
    end
  end
end
