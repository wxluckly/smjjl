class Product < ActiveRecord::Base
  # extends ...................................................................
  # includes ..................................................................
  include Patcher

  # security (i.e. attr_accessible) ...........................................
  attr_accessible :url, :url_key, :price_key, :name, :low_price

  # relationships .............................................................
  has_many :prices
  has_many :bargains
  has_one :product_info
  belongs_to :product_info

  # validations ...............................................................
  validates :url, uniqueness: { scope: :type }, if: "url.present?"
  validates :url_key, uniqueness: { scope: :type }, if: "url_key.present?"
  validate :verify_price_history

  # callbacks .................................................................
  before_save :clean_name
  after_save :record_bargain, if: "low_price_changed?"

  # scopes ....................................................................
  # scope :empty, -> { where("name is null or name = ''") }
  scope :empty, -> { where("image_url is null") }

  # additional config .........................................................
  serialize :price_history

  # class methods .............................................................
  # public instance methods ...................................................
  def record_price value
    value_f = value.to_f
    return if value_f <= 0
    # 回填初始的价格
    self.low_price = value_f if low_price.blank?
    # 记录价格历史
    self.price_history = (price_history || {}).merge({Date.today.strftime('%m-%d') => value_f.to_s})
    # 如果和上次价格记录不同，则记录新价格
    if last_price.blank? || value_f != last_price.to_f
      prices.create(value: value)
      self.last_price = value_f
    end
    # 记录新的历史最低
    self.low_price = value_f if value_f < low_price.to_f
    self.save
  end

  def to_param
    "#{id}-#{name.to_s.gsub(%r|[\/\s\\\(\)\.（）]|, "-")}"[0, 40]
  end

  def good_percent
    "#{score}%"
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
    discount = (low_price_was.to_f - low_price) / low_price_was.to_f
    return if discount < 0.05
    bargain = bargains.create(price: low_price, history_low: low_price_was, discount: discount)
    Category.classify(category).each do |category_id|
      BargainsCategory.create(bargain_id: bargain.id, category_id: category_id)
    end
  end

  def record_info info
    return if info.blank?
    pi = ProductInfo.find_or_initialize_by(product_id: self.id)
    pi.product = self
    pi.info = info
    pi.save
    self.product_info = pi
    self.save
  end

  def verify_price_history
    errors.add(:price_history, "只能存入hash,并且值为数组") if price_history.present? and !price_history.is_a?(Hash)
  end
end
