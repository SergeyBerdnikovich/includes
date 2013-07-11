# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :include_option do
    include_id 1
    option_id 1
    value "MyString"
  end
end
