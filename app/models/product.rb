class Product < ActiveRecord::Base
  # extends ...................................................................
  # includes ..................................................................
  include Patcher

  # security (i.e. attr_accessible) ...........................................
  attr_accessible :url, :url_key, :price_key, :name, :low_price

  # relationships .............................................................
  has_many :prices
  has_many :bargains
  has_and_belongs_to_many :categories

  # validations ...............................................................
  validates :url, uniqueness: { scope: :type }, if: "url.present?"
  validates :url_key, uniqueness: { scope: :type }, if: "url_key.present?"

  # callbacks .................................................................
  before_save :clean_name

  # scopes ....................................................................
  # scope :empty, -> { where("name is null or name = ''") }
  scope :empty, -> { where("info is null") }

  # additional config .........................................................
  # class methods .............................................................
  # public instance methods ...................................................
  def record_bargain value
    value_f = value.to_f
    return if value_f <= 0
    update(low_price: value_f) if low_price.blank?
    return if value_f == low_price.to_f
    prices.create(value: value)
    return if value_f > low_price.to_f
    if (low_price.to_f - value_f) / low_price.to_f > 0.05
      bargains.create(price: value_f, history_low: low_price)
    end
    update(low_price: value_f)
  end

  # protected instance methods ................................................
  # private instance methods ..................................................
  private
  def clean_name
    if self.name.present?
      self.name = self.name.gsub("\n", "").gsub("\r", "").strip
      self.name = self.name[0, 255]
    end
  end
end
