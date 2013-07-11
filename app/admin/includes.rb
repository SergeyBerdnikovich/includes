ActiveAdmin.register Include do
	index do
		column :name
		column :content
		column :include_file
		column :brand_id
		column :include_type_id
		column :user_id
		column :api_key
		column :created_at
		column :updated_at
		default_actions
	end

	show do |include|
		attributes_table do
			row :name
		row :content
		row :brand_id
		row :include_type_id
		row :user_id
		row :api_key
		row :created_at
		row :updated_at
			panel "Options:" do

				table_for include.include_options do

					column "Name" do |option|
						option.option.name
					end
					column "Type" do |option|
						option.option.option_type.name if option.option.option_type
					end
					column "Value" do |option|
						option.value
					end
				end
			end
		end
		  active_admin_comments
	end


	form do |f|

		f.inputs "Details" do
			f.input :name
			f.input :content
			f.input :brand_id
			f.input :include_type_id
			f.input :user_id
			f.input :api_key

			f.has_many :include_options do |include_option|
				include_option.input :option, :as => :select, :collection => Option.all
				include_option.input :value, :label => "Value"
			end


			f.actions
		end

	end
end

