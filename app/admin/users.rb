ActiveAdmin.register User do
  form do |f|
		f.inputs "Details" do
			f.input :name
			f.input :email
			f.input :coupon
			f.input :api_key
			f.input :account
		end
		f.actions
  end

end
