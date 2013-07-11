# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :statistic do
    include_id 1
    date 1
    views 1
  end
end
