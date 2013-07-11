# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :includeoption do
    include_id 1
    option_id 1
    value "MyString"
  end
end
