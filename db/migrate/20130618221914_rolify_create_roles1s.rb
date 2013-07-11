class RolifyCreateRoles1s < ActiveRecord::Migration
  def change

    create_table(:accounts_roles, :id => false) do |t|
      t.references :account
      t.references :role    
    end

    #add_index(:roles, :name)
    #add_index(:roles, [ :name, :resource_type, :resource_id ])
    add_index(:accounts_roles, [ :account_id, :role_id ])
  end
end
