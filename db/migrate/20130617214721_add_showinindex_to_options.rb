class AddShowinindexToOptions < ActiveRecord::Migration
  def change
    add_column :options, :show_in_index, :boolean
  end
end
