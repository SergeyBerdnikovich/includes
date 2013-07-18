module IncludesHelper

	def process_description(text,object)

		return "" if text == nil
		retval = text.clone
		if retval =~ /#user_api_key#/mi
			retval.gsub!(/#user_api_key#/mi, current_user.account.api_key)
		end
		if retval =~ /#include_api_key#/mi
			retval.gsub!(/#include_api_key#/mi, object.api_key)
		end

		if retval =~ /#include_id#/mi
			retval.gsub!(/#include_id#/mi, object.id.to_s)
		end

		retval
	end



	def generate_select(option, include_id)

		ret_text = ""
		case option.name
		when /brand_id/
			@brands = current_user.account.brands
			ret_text =  select_tag "options[#{option.id}]", options_from_collection_for_select(@brands, "brandid", "name",get_option_value(option.id, include_id, true))
		when /category_id/
			@categories = current_user.account.categories
			ret_text =  select_tag "options[#{option.id}]", options_from_collection_for_select(@categories, "categoryid", "name",get_option_value(option.id, include_id, true))
		when /product_id/
			@products = current_user.account.products
			ret_text =  select_tag "options[#{option.id}]", options_from_collection_for_select(@products, "productid", "name_with_id",get_option_value(option.id, include_id, true))
		end
		
		return ret_text


	end

end