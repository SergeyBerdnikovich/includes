class AddStripeToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :stripe_token, :string
  end
end
