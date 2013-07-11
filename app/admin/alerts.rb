ActiveAdmin.register Alert do
   index do
    column :account_id
    column :date
    column :alert_type
    column :des
    column :processed
    actions
  end
end
