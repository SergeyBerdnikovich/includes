class AddIncludetypeidToOptions < ActiveRecord::Migration
  def change
    add_column :options, :include_type_id, :integer
  end
end
