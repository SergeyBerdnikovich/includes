class AddUseridToBigcommerces < ActiveRecord::Migration
  def change
    add_column :bigcommerces, :user_id, :integer
  end
end
