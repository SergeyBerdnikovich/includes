class Statistic < ActiveRecord::Base
  attr_accessible :date, :include_id, :views
  belongs_to :include
end
