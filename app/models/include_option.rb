class IncludeOption < ActiveRecord::Base
  attr_accessible :include_id, :option_id, :value
  belongs_to :include
  belongs_to :option
end
