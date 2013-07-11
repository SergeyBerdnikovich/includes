class AddApikeyToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :api_key, :string
  end
end
