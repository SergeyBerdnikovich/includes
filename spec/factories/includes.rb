# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :include do
    name "MyString"
    content "MyText"
    brand_id 1
    include_type_id 1
  end
end
