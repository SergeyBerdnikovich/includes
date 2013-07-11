class IncludesController < ApplicationController
  # GET /includes
  # GET /includes.json
  before_filter :authenticate_user!
  
  include ApplicationHelper


  def index
    #@includes = Include.all  #we will request it in the view,because we will group it by include type
    @include_types = IncludeType.all
    respond_to do |format|
      format.html # index.html.erb
      format.json {
        if current_user
           @includes = Hash.new
          @includes[:error] = "0"
          @includes[:data] = current_user.account.includes.select("id, name, include_type_id")
        else
          @includes = Hash.new
          @includes[:error] = "1"
          @includes[:error_descrription]  = 'Authorization requierd'

        end
        render json: @includes
      }
    end
  end

  def get_options
    @options = IncludeType.find(params[:option_type_id]).options
    if params[:include_id].blank?
      @include_id = nil
    else
      @include_id = params[:include_id]
    end



    respond_to do |format|
      format.html { render :layout => false}
      format.json { render json: @options }
    end

  end

  # GET /includes/1
  # GET /includes/1.json
  def show
    @include = Include.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @include }
    end
  end

  # GET /includes/new
  # GET /includes/new.json
  def new

    unless new_include_possible
      redirect_to includes_path, :alert => "You may not create more new includes with your plan. To change plan please use Settings menu" and return true
    end

    @include = Include.new
    @include_type = @include.options.build()

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @include }
    end
  end

  # GET /includes/1/edit
  def edit
    @include = Include.find(params[:id])
  end

  # POST /includes
  # POST /includes.json
  def create

    unless new_include_possible
      redirect_to includes_path, :alert => "You may not create more new includes with your plan. To change plan please use Settings menu" and return true
    end

  if params[:include][:include_file]
      if action_possible("html_uploads", current_user) != true
        flash[:alert] = "Your plan doesn't allow HTML uploads. Please upgrade your plan first."
        render action: "new" 
        return false
      end
    end

    #save selected options and delete thus rails wouln't try to process it
    include_options = params[:options]
    params.delete(:options)

    @include = Include.new(params[:include])
    require 'securerandom'

    @include.api_key = SecureRandom.hex(16)
    @include.account = current_user.account


    respond_to do |format|
      if @include.save
        if include_options
          include_options.each_with_index do |(key, val), i|
            #saving array of options that were generated dinamically by JS
            IncludeOption.new(:include_id => @include.id, :option_id => key, :value => val).save
          end
        end


        format.html { redirect_to includes_path, notice: 'Include was successfully created.' }
        format.json { render json: @include, status: :created, location: @include }
      else
        format.html { render action: "new" }
        format.json { render json: @include.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /includes/1
  # PUT /includes/1.json
  def update



    @include = Include.find(params[:id])
    if params[:include][:include_file]
      if action_possible("html_uploads", current_user) != true
        flash[:alert] = "Your plan doesn't allow HTML uploads. Please upgrade your plan first."
        render action: "edit" 
        return false
      end
    end
    include_options = params[:options]
    if include_options
      IncludeOption.where("include_id = ?",@include.id ).delete_all
    end

    respond_to do |format|
      if @include.update_attributes(params[:include])

        @include.include_file = params[:include_file]
        @include.save!
        if include_options
          include_options.each_with_index do |(key, val), i|
            IncludeOption.new(:include_id => @include.id, :option_id => key, :value => val).save
          end
        end

        format.html { redirect_to includes_path, notice: 'Include was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @include.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /includes/1
  # DELETE /includes/1.json
  def destroy
    @include = Include.find(params[:id])
    @include.destroy

    respond_to do |format|
      format.html { redirect_to includes_url }
      format.json { head :no_content }
    end
  end
end
