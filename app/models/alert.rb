class Alert < ActiveRecord::Base
  attr_accessible :account_id, :date, :des, :processed, :alert_type
end
