class AddAccountidToIncludes < ActiveRecord::Migration
  def change
    add_column :includes, :account_id, :integer
  end
end
