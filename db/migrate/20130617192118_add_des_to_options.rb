class AddDesToOptions < ActiveRecord::Migration
  def change
    add_column :options, :des, :text
  end
end
