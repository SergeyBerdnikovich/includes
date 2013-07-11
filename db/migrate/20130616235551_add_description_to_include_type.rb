class AddDescriptionToIncludeType < ActiveRecord::Migration
  def change
    add_column :include_types, :des, :text
  end
end
