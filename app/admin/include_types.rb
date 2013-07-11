ActiveAdmin.register IncludeType do
	menu :parent => "Project settings"

	form do |f|
		f.inputs "Details" do
			f.input :name
			f.input :des
			f.input :des_instead_of_name
		end
		f.has_many :options do |option|

			option.input :name, :label => "Name, for API, like 'product_qty'"
			option.input :title, :label => "Title, for clients, like 'Quantity of products'"
			option.input :option_type, :as => :select, :collection => OptionType.all, :label => "Type of option (which control element would be shown)"
			option.input :show_in_index, :as => :boolean , :label => "Show this option and value in index page of includes (or only in edit page)"
			option.input :_destroy, :as => :boolean, :required => false, :label=>'Remove'

		end
		f.actions
	end

	show do |include_type|
		attributes_table do
			row :name
			row :des
			row :des_instead_of_name
			panel "Available options:" do

				table_for include_type.options do

					column "Name" do |option|
						option.name
					end
					column "Title" do |option|
						option.title
					end
				end
			end
		end
		  active_admin_comments
	end



end
