class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    authorize! :index, @user, :message => 'Not authorized as an administrator.'
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new

    @user = User.new(params[:user])
  end

  def attach
    if params[:user]
      if params[:user][:email] =~ /(?:[a-z0-9!\x23$%&'*+\/=?^_`{|}~-]+(?:\.[a-z0-9!\x23$%&'*+\/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])/m
        check_user = User.where("email = '?'", params[:user][:email]).first
        unless check_user
          @user = User.new params[:user]
          require 'securerandom'
          @user.password = SecureRandom.hex(16)
          @user.reset_password_token = SecureRandom.hex(32)
          @user.account = current_user.account

          UserMailer.attach_user(@user, current_user, params[:comment]).deliver
          #@user.skip_confirmation! # Sets confirmed_at to Time.now, activating the account
          @user.save
          redirect_to edit_user_registration_path
        else
          redirect_to new_user_path(params), :alert => "User with this email already have an account. Please ask this user to delete his current account and then try to attach him once again."
        end
      else
        redirect_to new_user_path(params), :alert => "Please specify correct email"
      end
    end
  end

  def update
    authorize! :update, @user, :message => 'Not authorized as an administrator.'
    @user = User.find(params[:id])
    role = Role.find(params[:user][:role_ids]) unless params[:user][:role_ids].nil?
    params[:user] = params[:user].except(:role_ids)
    if @user.update_attributes(params[:user])
      @user.update_plan(role) unless role.nil?
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
  end

  def destroy
    #   authorize! :destroy, @user, :message => 'Not authorized as an administrator.'
    user = User.find(params[:id])
    if current_user != user
      user.destroy
      redirect_to edit_user_registration_path, :notice => "User deleted."
    else
      redirect_to edit_user_registration_path, :notice => "Can't delete yourself."
    end
  end
end