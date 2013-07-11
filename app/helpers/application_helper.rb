module ApplicationHelper

  def parse_short_date(date_string) # form datetime object instead of short date
    DateTime.parse(date_string,"%Y%m%d")
  end

  def limits(value)

    return "Unlimited" if value == 0

    value

  end

  def new_include_possible(user = nil)
    user = current_user if user == nil
    if user.account.plan.includes != 0 # 0 is unlimited
    return false if user.account.includes.count >= user.account.plan.includes
    end
    return true
  end

  def action_possible(action, user = nil)
    user = current_user if user == nil
    val = true
    val = user.account.plan.try(action)
    if val == false
    next_where_possible = Plan.where("#{action} = 1").order('price ASC').first
      if next_where_possible != nil
        return "This feature isn't available until you have " + next_where_possible.name + " plan or highier"
      else
        return "This feature isn't available at your plan"
      end

    end
    true
  end


  def plan_possible(plan, user = nil)
    user = current_user if user == nil
    possible = true
    why = ""
    if plan.includes != 0
      if user.account.includes.count > plan.includes
        possible = false
        why += "<br>You have #{user.account.includes.count} includes while this plan can support only #{plan.includes} includes<br>"
      end
    end

    #tricky process of boolean variables
    api_options = [["api_shortcodes","API Shortcodes"]#,
      #["html_uploads", "HTML Uploads"],
      #["advanced_includes","Advanced Includes"]
    ]
    api_options.each do |api_option|

      warned = false # to include description of error only once
      user.account.includes.each do |include|
        begin
          if plan.try(api_option[0]) == false
            include.include_options.each do |include_option|
              if include_option.option.name == api_option[0] and include_option.option = "on"
                if warned == false
                  possible = false
                  why += "<br>Following includes uses #{api_option[1]} that unavailable at this plan: "
                  warned = true
                end
                why += " " + link_to(include.name,edit_include_path(include)) + " ; "
              end
            end
          end
        rescue
        end
      end

    end

    #processing attached files
    warned = false # to include description of error only once
    user.account.includes.each do |include|
      begin
        if plan.html_uploads == false
          unless include.include_file.blank?
            if warned == false
              possible = false
              why += "<br>Following includes have HTML Uploads that unavailable at this plan: "
              warned = true
            end
            why += " " + link_to(include.name,edit_include_path(include)) + " <br> "
          end

        end
      rescue
      end
    end


    if possible == true
      return true
    else
      return "<b>Change to this plan isn't possible</b> <br> " + why
    end
  end



  def get_option_value(option_id, include_id, id_only = false)
    @includeoption = IncludeOption.where('include_id = ? AND option_id = ?', include_id, option_id)
    value = ""
    if @includeoption.size != 0
      @includeoption = @includeoption.first
      if id_only == true
        value = @includeoption.value
      else
        if @includeoption.option.name =~ /brand_id/mi
         brand = Brand.where("brandid = ? AND account_id = ?", @includeoption.value, current_user.account.id).first        
          value = brand.name + "(#{brand.brandid})" if brand
        elsif @includeoption.option.name =~ /category_id/mi
          cat = Category.where("categoryid = ? AND account_id = ?", @includeoption.value, current_user.account.id).first          
          value = cat.name + "(#{cat.categoryid})" if cat
        elsif @includeoption.option.name =~ /product_id/mi
          cat = Product.where("productid = ? AND account_id = ?", @includeoption.value, current_user.account.id).first          
          value = cat.name + "(#{cat.productid})" if cat

        else
          value = @includeoption.value
        end
      end
    end
    #workaround for checkboxes when they are absend the value should be false
    @option = Option.find(option_id)
    if @option.option_type
      if @option.option_type.name == 'boolean'
        if value == 'on'
          value = true
        else
          value = false
        end
      end
    end

    value

  end


  def display_base_errors resource
    return '' if (resource.errors.empty?) or (resource.errors[:base].empty?)
    messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
    html = <<-HTML
    <div class="alert alert-error alert-block">
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
      #{messages}
    </div>
    HTML
    html.html_safe
  end

end
