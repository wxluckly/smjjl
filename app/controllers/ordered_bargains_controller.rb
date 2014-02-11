class OrderedBargainsController < ApplicationController
  def index
    # 10小时内，降价幅度最大的100件商品
    @bargains = Bargain.where("created_at > ?", 10.hours.ago).limit(100).order("discount desc")
  end
end
