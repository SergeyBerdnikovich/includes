class Image < ActiveRecord::Base
  attr_accessible :description, :image_file, :imageid, :productid, :account_id
  belongs_to :account
end
