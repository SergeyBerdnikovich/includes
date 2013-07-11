class AddUseridToIncludes < ActiveRecord::Migration
  def change
    add_column :includes, :user_id, :integer
  end
end
