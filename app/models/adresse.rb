class Adresse < ActiveRecord::Base
has_many :orders
attr_accessible :available, :order_id # attr_accessible needed otherwise, update_attributes does NOT work on those attributes. 
# Beware of mass assignment vulnerability

end
