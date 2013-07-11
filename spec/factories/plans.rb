# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :plan do
    includes 1
    impressions 1
    api_shortcodes false
    html_uploads false
    advanced_logic false
    support "MyString"
    price 1.5
  end
end
