class AddIncludefileToIncludes < ActiveRecord::Migration
  def change
    add_column :includes, :include_file, :string
  end
end
