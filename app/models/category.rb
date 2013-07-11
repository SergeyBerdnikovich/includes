class Category < ActiveRecord::Base
  attr_accessible :categoryid, :description, :image_file, :image_tag, :name, :page_title, :parent_id, :url, :account_id
end
