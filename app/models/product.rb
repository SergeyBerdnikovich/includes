class Product < ActiveRecord::Base
	self.inheritance_column = :_type_disabled
  attr_accessible :account_id, :availability, :availability_description, :brand_id, :calculated_price, :condition, :cost_price, :custom_url, :date_created, :date_modified, :depth, :description, :height, :inventory_level, :name, :page_title, :price, :productid, :retail_price, :sale_price, :sku, :total_sold, :type, :upc, :view_count, :warranty, :weight, :width, :updated_at, :processed
  belongs_to :account
  attr_accessor :name_with_id

  def name_with_id
  	"#{self.productid} - #{self.name}"
  end

end
