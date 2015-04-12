class Truck < ActiveRecord::Base
  belongs_to :brand_truck
  belongs_to :type_truck
  belongs_to :city
  belongs_to :state



  HUMANIZED_ATTRIBUTES = {
      :nombre => 'Nombre',
      :city_id => 'Ciudad',
      :state_id => 'Departamento',
      :brand_truck => 'Marca',
      :type_truck => 'Tipo'
  }




  def self.human_attribute_name(attr, options = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end



  validates :nombre, presence: true
  validates :state_id, presence: true
  validates :city_id, presence: true
  validates :brand_truck, presence: true
  validates :type_truck, presence: true



  before_create do

    self.link_rewrite = self.nombre.downcase
    self.link_rewrite = I18n.transliterate(self.link_rewrite)

    if self.nombre.count(' ') >= 1
      self.link_rewrite = self.link_rewrite.gsub! ' ', '-'
    end

  end


  before_update do

    self.link_rewrite = self.nombre.downcase
    self.link_rewrite = I18n.transliterate(self.link_rewrite)

    if self.nombre.count(' ') >= 1
      self.link_rewrite = self.link_rewrite.gsub! ' ', '-'
    end

  end


end
