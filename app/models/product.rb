class Product < ActiveRecord::Base
  # extends ...................................................................
  # includes ..................................................................
  include Patcher

  # security (i.e. attr_accessible) ...........................................
  attr_accessible :url, :url_key, :price_key, :name, :low_price

  # relationships .............................................................
  has_many :prices
  has_many :bargains
  
  # validations ...............................................................
  validates :url, uniqueness: { scope: :type }, if: "url.present?"
  validates :url_key, uniqueness: { scope: :type }, if: "url_key.present?"

  # callbacks .................................................................
  before_save :clean_name

  # scopes ....................................................................
  scope :empty, -> { where(name: nil) }

  # additional config .........................................................
  # class methods .............................................................
  # public instance methods ...................................................
  def record_bargain value
    return if value.to_f == low_price.to_f
    prices.create(value: value)
    return if value.to_f > low_price.to_f
    bargains.create(price: value, history_low: low_price)
    update(low_price: value)
  end

  # protected instance methods ................................................
  # private instance methods ..................................................
  private
  def clean_name
    self.name = self.name.gsub("\n", "").gsub("\r", "").strip if self.name.present?
  end
end
