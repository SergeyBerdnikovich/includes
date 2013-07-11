class AddDigitToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :last_4_digits, :integer
  end
end
