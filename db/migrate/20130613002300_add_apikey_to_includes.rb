class AddApikeyToIncludes < ActiveRecord::Migration
  def change
    add_column :includes, :api_key, :string
  end
end
