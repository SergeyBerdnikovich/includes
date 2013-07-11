class AddDesinsteadofnameToIncludeTypes < ActiveRecord::Migration
  def change
    add_column :include_types, :des_instead_of_name, :bool
  end
end
