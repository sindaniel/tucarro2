class Extra < ActiveRecord::Base


  belongs_to :brand_extra
  belongs_to :type_extra
  belongs_to :city
  belongs_to :state


  validates :name, presence: true
  validates :state_id, presence: true
  validates :city_id, presence: true
  validates :brand_extra_id, presence: true
  validates :type_extra_id, presence: true



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
