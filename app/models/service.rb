class Service < ActiveRecord::Base

  belongs_to :type_service
  belongs_to :city
  belongs_to :state
  belongs_to :customer


  has_many :messages, -> { where(tipo: 3)}, :foreign_key => :item





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





  before_create do

    self.link_rewrite = self.name.downcase
    self.link_rewrite = I18n.transliterate(self.link_rewrite)

    if self.name.count(' ') >= 1
      self.link_rewrite = self.link_rewrite.gsub! ' ', '-'
    end

  end


  before_update do

    self.link_rewrite = self.name.downcase
    self.link_rewrite = I18n.transliterate(self.link_rewrite)

    if self.name.count(' ') >= 1
      self.link_rewrite = self.link_rewrite.gsub! ' ', '-'
    end

  end


end
