class Brand < ActiveRecord::Base
  attr_accessible :name, :account_id, :brandid,:page_title,:meta_keywords,:meta_description,:image_file,:search_keywords

  has_many :includes
  belongs_to :account
end
