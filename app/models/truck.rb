class Truck < ActiveRecord::Base
  belongs_to :brand_truck
  belongs_to :type_truck
  belongs_to :city
  belongs_to :state



  HUMANIZED_ATTRIBUTES = {
      :nombre => 'Nombre'
  }




  def self.human_attribute_name(attr, options = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end



  validates :nombre, presence: true
  validates :state_id, presence: true
  validates :city_id, presence: true


end
