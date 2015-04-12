class Truck < ActiveRecord::Base
  belongs_to :brand_truck
  belongs_to :type_truck


end
