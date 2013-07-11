class Plan < ActiveRecord::Base
  attr_accessible :advanced_logic, :api_shortcodes, :html_uploads, :impressions, :includes, :price, :support, :name, :api_name
  has_many :accounts
  
end
