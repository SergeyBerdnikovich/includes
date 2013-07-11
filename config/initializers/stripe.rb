Stripe.api_key = "sk_test_sAg4zilp0YzNDwhQZgVqvViR"
STRIPE_PUBLIC_KEY = "pk_test_zZzDFq1Rprdtr5HRuq0f9N30"

StripeEvent.setup do
  subscribe 'customer.subscription.deleted' do |event|
    user = Account.find_by_customer_id(event.data.object.customer)
    user.expire
  end
end