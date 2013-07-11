class PlansController < ApplicationController
  # GET /bigcommerces
  # GET /bigcommerces.json
  before_filter :authenticate_user!

  def index
    if current_user.account.plan
      redirect_to edit_plan_path(current_user.account.plan)
    else
      redirect_to new_plan_path
    end

  end

  def card
  end


  # GET /bigcommerces/1
  # GET /bigcommerces/1.json
  def show
    @plan = current_user.account.plan
    redirect_to edit_user_registration_path(), :notice => "Bigcommerce data is scheduled to be downloaded" and return true
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @plan }
    end
  end

  # GET /bigcommerces/new
  # GET /bigcommerces/new.json
  def new
    if current_user.account.plan
      redirect_to edit_plan_path(current_user.account.plan) and return true
    end
    @plan = Plan.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @plan }
    end
  end

  # GET /bigcommerces/1/edit
  def edit
    @plan = current_user.account.plan
  end

  # POST /bigcommerces
  # POST /bigcommerces.json
  def create
    @plan = Plan.new(params[:plan])
    @plan.account = current_user.account
    respond_to do |format|
      if @plan.save

        format.html { redirect_to edit_user_registration_path(), notice: 'Plan has been successfully updated' }
        format.json { render json: @plan, status: :created, location: @plan }
      else
        format.html { render action: "new" }
        format.json { render json: @plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /bigcommerces/1
  # PUT /bigcommerces/1.json
  def update
    @plan = current_user.account.plan

    respond_to do |format|
      if @plan.update_attributes(params[:plan])
        format.html { redirect_to edit_user_registration_path, notice: 'Plan has been successfully updated' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bigcommerces/1
  # DELETE /bigcommerces/1.json
  def destroy
    @plan = Plan.find(params[:id])
    @plan.destroy

    respond_to do |format|
      format.html { redirect_to plans_url }
      format.json { head :no_content }
    end
  end
end
