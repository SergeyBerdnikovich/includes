class AddOptiontypeidToOptions < ActiveRecord::Migration
  def change
    add_column :options, :option_type_id, :integer
  end
end
