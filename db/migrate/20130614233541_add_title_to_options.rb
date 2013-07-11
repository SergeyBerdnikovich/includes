class AddTitleToOptions < ActiveRecord::Migration
  def change
    add_column :options, :title, :string
  end
end
