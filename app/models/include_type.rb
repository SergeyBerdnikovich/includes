class IncludeType < ActiveRecord::Base
  attr_accessible :name, :options_attributes, :des, :des_instead_of_name

  has_many :include
  has_many :options
  accepts_nested_attributes_for :options, allow_destroy: true
end
