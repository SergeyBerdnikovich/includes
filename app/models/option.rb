class Option < ActiveRecord::Base
  attr_accessible :name, :title, :des, :include_type_id, :option_type_id,:show_in_index
  belongs_to :include_type
  belongs_to :option_type
  has_many :include_options
  has_many :includes, :through => :include_options

end
