class Include < ActiveRecord::Base
  attr_accessible :brand_id, :content, :include_type_id, :name, :account_id, :api_key, :option_ids, :include_options_attributes, :include_file, :remove_include_file
  mount_uploader :include_file, IncludeUploader
  belongs_to :include_type
  belongs_to :brand
  belongs_to :account
  has_many :statistics, :dependent => :destroy
  has_many :include_options, :dependent => :destroy
  has_many :options, :through => :include_options
  accepts_nested_attributes_for :include_options, :allow_destroy => true

end
