task :alerts => :environment do
	puts "Processing alerts"
	Alert.where('processed != 1 OR processed IS NULL').each do |alert|
		@account = Account.where("id = ?",alert.account_id).first
		if @account
			@account.users.each do |user|
				case alert.alert_type
				when "limit_reached"
					text = "Hello! <p>
					Your includes in account #{@account.name} reach its view limit. <br>
					They are not shown any more. Please upgrade your plan to have more limits. 

					To do so please go to <a href='http://includes.io/users/edit'>your account settings</a>
					"
					UserMailer.send_alert(user.email,text).deliver
					p "message sent to #{user.email}"
					alert.update_attribute("processed",true)
				end
			end
		end

	end
	puts "done."
end