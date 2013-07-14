class RegistrationsController < Devise::RegistrationsController

  def new
    #@plan = params[:plan]
    #if @plan && ENV["ROLES"].include?(@plan) && @plan != "admin"
    super
    #else
    #  redirect_to root_path, :notice => 'Please select a subscription plan below.'
    #end
  end

  def destroy
    if current_user.has_role? "admin"
      current_user.account.delete
    else
      current_user.delete
    end
    super
  end

  def update_plan(plan_id = nil)
    @user = current_user
    if current_user.account.last_4_digits
      plan_id = params[:plan_id] unless plan_id      
      plan = Plan.find(plan_id) unless plan_id.nil?
      if @user.update_plan(plan)
        session[:plan_id] = nil
        redirect_to edit_user_registration_path, :notice => 'Plan has been updated.'
      else
        flash.alert = 'Unable to update plan.'
        render :edit
      end
    else
      session[:plan_id] = params[:plan_id]
      redirect_to plans_card_path(), :notice => "Please specify your credit card"
    end
  end
  def create
    super
  end



  def update_card
    @account = current_user.account
    @account.stripe_token = params[:account][:stripe_token]
    if @account.save
      current_user.update_stripe
      if session[:plan_id]
        update_plan(session[:plan_id])
      else
      redirect_to edit_user_registration_path, :notice => 'Card has been updated'
      end
    else
      flash.alert = 'Unable to update card.'
      render :edit
    end
  end

  private
  def build_resource(*args)
    super
    if params[:plan]
      #   resource.add_role(params[:plan])
    end
  end
end
