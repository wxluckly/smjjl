class Product < ActiveRecord::Base
  # extends ...................................................................
  # includes ..................................................................
  include Patcher

  # security (i.e. attr_accessible) ...........................................
  attr_accessible :url, :url_key, :price_key, :name, :low_price, :category, :image_url, :is_discontinued, :type

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
  after_save :record_bargain

  # scopes ....................................................................
  # scope :empty, -> { where("name is null or name = ''") }
  scope :empty, -> { where("has_content is false") }

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
    self.price_history = slice_hash (price_history || {}).merge({Date.today.strftime('%m-%d') => value_f.to_s})
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

  # 记录超值产品，
  def record_bargain
    return if last_price.to_f > last_price_was.to_f
    discount = (last_price_was.to_f - last_price.to_f) / last_price_was.to_f
    history_discount = (low_price_was.to_f - low_price.to_f) / low_price_was.to_f
    if history_discount > 0.01
      # 当比历史低价低1%的时候，进行记录
      bargain = bargains.create(price: last_price, history_low: last_price_was, discount: discount)
      Category.classify(category).each do |category_id|
        BargainsCategory.create(bargain_id: bargain.id, category_id: category_id)
      end
    elsif discount > 0.2
      # 当比之前价格低20%的时候，进行记录
      bargain = bargains.create(price: last_price, history_low: last_price_was, discount: discount)
      Category.classify(category).each do |category_id|
        BargainsCategory.create(bargain_id: bargain.id, category_id: category_id)
      end
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

  def slice_hash hash
    Hash[hash.to_a.reverse[0, 60].reverse]
  end
end
