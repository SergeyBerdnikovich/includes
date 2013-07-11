# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :alert do
    date 1
    type ""
    des "MyText"
    processed false
    account_id 1
  end
end
