class User < ActiveRecord::Base
  rolify :role_cname => 'Role'
  after_create :create_account
  include ApplicationHelper


  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :stripe_token, :coupon, :api_key, :account_id
  attr_accessor :stripe_token, :coupon
  #before_save :update_stripe
  belongs_to :account

  def create_account
    if self.account_id == nil
      require 'securerandom'
      @account = Account.new(:name => self.name, :api_key => SecureRandom.hex(13))
      @account.plan = Plan.where('price = 0').first
      @account.save

      @user = User.find(self.id)
      @user.account = @account
      @user.add_role :admin
      @user.save
    end
  end

  def update_plan(plan)
    #self.account.role_ids = []
    #self.account.add_role(role.name)
    #unless self.account.customer_id.nil?
    if plan_possible(plan,self) != true
      errors.add :base, "Unable to update your subscription to this plan."  
      return false
    end
    @account = self.account
    if @account.customer_id.nil?
      update_stripe 
    end

    if @account.customer_id 
      customer = Stripe::Customer.retrieve(self.account.customer_id)
      customer.update_subscription(:plan => plan.api_name)
      @account.plan = plan
      @account.save
    end
    true
  rescue Stripe::StripeError => e
    logger.error "Stripe Error: " + e.message
    errors.add :base, "Unable to update your subscription. #{e.message}."
    false
  end

  def update_stripe
  begin
    customer = nil
    if account.customer_id == nil
     
      if !account.stripe_token.present?
        #raise "Stripe token not present. Can't create account."
        errors.add :base, "Please set up Credit Card first, using \"Card\" menu bellow"
        false
      end
      if self.account.coupon.blank?
        customer = Stripe::Customer.create(
        :email => email,
        :description => name,
        :card => account.stripe_token,
        :plan => Plan.all.first.api_name
        )
      else
        customer = Stripe::Customer.create(
        :email => email,
        :description => name,
        :card => account.stripe_token,
        :plan => Plan.all.first.api_name,
        :coupon => coupon
        )
      end
    else
      customer = Stripe::Customer.retrieve(account.customer_id)
      
      if account.stripe_token.present?
        customer.card = account.stripe_token
      end
      customer.email = email
      customer.description = name
      customer.save
    end
    
    account.last_4_digits = customer.active_card.last4 if customer.active_card
    account.customer_id = customer.id
    account.stripe_token = nil
    account.save
  rescue Exception => e
    raise e
    logger.error "Stripe Error: " + e.message
    errors.add :base, "#{e.message}."
    self.stripe_token = nil
    false
  end
  end



  def expire
    UserMailer.expire_email(self).deliver
    destroy
  end

end
