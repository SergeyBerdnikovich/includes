class ApplicationController < ActionController::Base
	protect_from_forgery

	# rescue_from CanCan::AccessDenied do |exception|
	#   redirect_to root_path, :alert => exception.message
	# end

	def change_include_possible(include,user)
		
  	end

	def include_possible(include)

	end

	def parse_integer(string) #function to parse only integer values out of the string
		integer = string.gsub(/[^0-9]/,"").to_i

		integer
	end

	def parse_short_date(date_string) # form datetime object instead of short date
		DateTime.parse(date_string,"%Y%m%d")
	end

	def after_sign_in_path_for(resource)
		dashboard_path()
	end

end