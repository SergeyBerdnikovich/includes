class AddApinameToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :api_name, :string
  end
end
