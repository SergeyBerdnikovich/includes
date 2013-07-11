class Account < ActiveRecord::Base
  rolify :role_cname => 'Roles1'
  attr_accessible :name, :api_key ,:coupon ,:stripe_token ,:customer_id ,:last_4_digits, :plan_id



  before_destroy :cancel_subscription
  has_many :includes, :dependent => :destroy
  has_many :users, :dependent => :destroy
  has_many :statistics, :through => :includes
  has_many :brands, :dependent => :destroy
  has_many :images, :dependent => :destroy
  has_many :categories, :dependent => :destroy
  has_many :products, :dependent => :destroy
  has_one :bigcommerce_account, :dependent => :destroy
  belongs_to :plan

  rolify

  def cancel_subscription
    unless customer_id.nil?
      customer = Stripe::Customer.retrieve(customer_id)

      unless customer.nil? or customer.respond_to?('deleted')
        if customer.subscription
          if customer.subscription.status == 'active'
            customer.cancel_subscription
          end
        end
      end
    end
  rescue Stripe::StripeError => e
    logger.error "Stripe Error: " + e.message
    errors.add :base, "Unable to cancel your subscription. #{e.message}."
    false
  end

end
