# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product do
    productid ""
    name ""
    type ""
    sku ""
    description ""
    availability ""
    availability_description ""
    price ""
    cost_price ""
    retail_price ""
    sale_price ""
    calculated_price ""
    inventory_level ""
    warranty ""
    weight ""
    width ""
    height ""
    depth ""
    total_sold ""
    date_created ""
    brand_id ""
    view_count ""
    page_title ""
    date_modified ""
    condition ""
    upc ""
    custom_url ""
    account_id 1
  end
end
