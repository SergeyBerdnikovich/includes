class OptionType < ActiveRecord::Base
  attr_accessible :name
  has_many :options
end
