class Invoice < ActiveRecord::Base
belongs_to :order

attr_accessible :amount_paid, :status
 # attr_accessible needed otherwise, update_attributes does NOT work on those attributes. Beware of mass assignment vulnerability.

STATUS = [ "pending","partial", "paid", "excess"]

validates :status, :presence => true
validates :status, :inclusion => STATUS


end
