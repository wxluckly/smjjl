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
  has_one :product_info
  belongs_to :product_info

  # validations ...............................................................
  validates :url, uniqueness: { scope: :type }, if: "url.present?"
  validates :url_key, uniqueness: { scope: :type }, if: "url_key.present?"

  # callbacks .................................................................
  before_save :clean_name
  after_save :record_bargain, if: "low_price_changed?"

  # scopes ....................................................................
  # scope :empty, -> { where("name is null or name = ''") }
  scope :empty, -> { where("product_info_id is null") }

  # additional config .........................................................
  # class methods .............................................................
  # public instance methods ...................................................
  def record_price value
    value_f = value.to_f
    return if value_f <= 0
    prices.create(value: value)
    # 没有历史最低价，就写入第一次的价格
    update(low_price: value_f) if low_price.blank?
    # 记录新的历史最低
    update(low_price: value_f) if value_f < low_price.to_f
  end

  def to_param
    "#{id}-#{name.to_s.gsub(%r|[\/\s\\\(\)（）]|, "-")}"[0, 40]
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

  # 记录超值产品，只有降价幅度达到5%以上的时候，才进行记录
  def record_bargain
    if (low_price_was.to_f - low_price) / low_price_was.to_f > 0.05
      bargains.create(price: low_price, history_low: low_price_was)
    end
  end

  def record_info info
    pi = ProductInfo.find_or_initialize_by(product_id: self.id)
    pi.product = self
    pi.info = info
    pi.save
    self.product_info = pi
    self.save
  end
end
