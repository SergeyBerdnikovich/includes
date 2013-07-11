ActiveAdmin.register Option do
  menu :parent => "Project settings"
  index do
  	column :name
    column :include_type_id
    column :title
    column :des
    column :show_in_index
    column :option_type_id do |option|
    	option.option_type.name if option.option_type
    end
    default_actions
  end
end
