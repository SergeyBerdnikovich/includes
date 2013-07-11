class CreateOptionTypes < ActiveRecord::Migration
  def change
    create_table :option_types do |t|
      t.string :name

      t.timestamps
    end
     # populate the table
      OptionType.create :name => "select"
      OptionType.create :name => "string"
      OptionType.create :name => "boolean"

  end
end
