class BigcommerceAccountsController < ApplicationController
  # GET /bigcommerces
  # GET /bigcommerces.json
  before_filter :authenticate_user!

  def index
    if current_user.account.bigcommerce_account
      redirect_to edit_bigcommerce_account_path(current_user.account.bigcommerce_account)
    else
      redirect_to new_bigcommerce_account_path
    end

  end

  # GET /bigcommerces/1
  # GET /bigcommerces/1.json
  def show

    require 'bigcommerce'
    @bigcommerce = current_user.account.bigcommerce_account
    begin
      api = Bigcommerce::Api.new({
        :store_url => @bigcommerce.store_url,
        :username  => @bigcommerce.username,
        :api_key   => @bigcommerce.api_key
      })
    rescue Exception => e
      redirect_to edit_bigcommerce_account_path(current_user.account.bigcommerce_account), :alert => "API settings you have provided aren't working. Please check them." and return false
    end

    BigcommerceAccount.delay.download_data(@bigcommerce)

    #@test = api.get_product_images(1)

    redirect_to edit_user_registration_path(), :notice => "Bigcommerce data is scheduled to be downloaded" and return true
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @bigcommerce }
    end
  end

  # GET /bigcommerces/new
  # GET /bigcommerces/new.json
  def new
    if current_user.account.bigcommerce_account
      redirect_to edit_bigcommerce_account_path(current_user.account.bigcommerce_account) and return true
    end
    @bigcommerce = BigcommerceAccount.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @bigcommerce }
    end
  end

  # GET /bigcommerces/1/edit
  def edit
    @bigcommerce = current_user.account.bigcommerce_account
  end

  # POST /bigcommerces
  # POST /bigcommerces.json
  def create
    @bigcommerce = BigcommerceAccount.new(params[:bigcommerce_account])
    @bigcommerce.account = current_user.account
    respond_to do |format|
      if @bigcommerce.save


        require 'bigcommerce'
        @bigcommerce = current_user.account.bigcommerce_account
        begin
          api = Bigcommerce::Api.new({
            :store_url => @bigcommerce.store_url,
            :username  => @bigcommerce.username,
            :api_key   => @bigcommerce.api_key
          })
        rescue Exception => e
          redirect_to edit_bigcommerce_account_path(current_user.account.bigcommerce_account) and return true, :alert => "API settings you have provided aren't working. Please check them." and return false
        end

        BigcommerceAccount.delay.download_data(@bigcommerce)

        format.html { redirect_to edit_user_registration_path(), notice: 'Bigcommerce setting was successfully created.' }
        format.json { render json: @bigcommerce, status: :created, location: @bigcommerce }
      else
        format.html { render action: "new" }
        format.json { render json: @bigcommerce.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /bigcommerces/1
  # PUT /bigcommerces/1.json
  def update
    @bigcommerce = current_user.account.bigcommerce_account

    respond_to do |format|
      if @bigcommerce.update_attributes(params[:bigcommerce_account])
        format.html { redirect_to bigcommerce_account_path(current_user.account.bigcommerce_account), notice: 'Bigcommerce setting was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @bigcommerce.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bigcommerces/1
  # DELETE /bigcommerces/1.json
  def destroy
    @bigcommerce = BigcommerceAccount.find(params[:id])
    @bigcommerce.destroy

    respond_to do |format|
      format.html { redirect_to bigcommerce_accounts_url }
      format.json { head :no_content }
    end
  end
end
