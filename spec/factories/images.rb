# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :image do
    imageid 1
    productid 1
    image_file "MyString"
    description "MyString"
  end
end
