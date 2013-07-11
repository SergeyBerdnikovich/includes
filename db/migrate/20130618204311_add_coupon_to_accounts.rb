class AddCouponToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :coupon, :string
  end
end
