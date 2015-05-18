class Truck < ActiveRecord::Base
  belongs_to :brand_truck
  belongs_to :type_truck
  belongs_to :city
  belongs_to :state







  has_attached_file :picture1, :styles => {:home => '548x300>', :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/missing.png"
  validates_attachment_content_type :picture1, :content_type => /\Aimage\/.*\Z/


  has_attached_file :picture2, :styles => {:home => '548x300>', :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/missing.png"
  validates_attachment_content_type :picture2, :content_type => /\Aimage\/.*\Z/

  has_attached_file :picture3, :styles => {:home => '548x300>', :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/missing.png"
  validates_attachment_content_type :picture3, :content_type => /\Aimage\/.*\Z/

  has_attached_file :picture4, :styles => {:home => '548x300>', :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/missing.png"
  validates_attachment_content_type :picture4, :content_type => /\Aimage\/.*\Z/

  has_attached_file :picture5, :styles => {:home => '548x300>', :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/missing.png"
  validates_attachment_content_type :picture5, :content_type => /\Aimage\/.*\Z/



  validates :nombre, presence: true
  validates :modelo, presence: true
  validates :brand_truck_id, presence: true
  validates :type_truck_id, presence: true
  validates :state_id, presence: true
  validates :city_id, presence: true

  validates :kilometraje, presence: true
  validates :estado, presence: true
  validates :placa, presence: true
  validates :tipocombustible, presence: true
  validates :color, presence: true
  validates :placa_city_id, presence: true

  validates :placa_state_id, presence: true



  HUMANIZED_ATTRIBUTES = {
      :nombre => 'Nombre',
      :city_id => 'Ciudad',
      :state_id => 'Departamento',
      :brand_truck_id => 'Marca',
      :type_truck_id => 'Tipo',
      :tipocombustible => 'Tipo combustible',
      :placa_city_id => 'Ciudad Matricula',
      :placa_state_id => 'Departamento Matricula'

  }

  def self.human_attribute_name(attr, options = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end






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
