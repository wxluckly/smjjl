class AjaxController < ApplicationController
  def get_prices
    # prices_hash = {"历史最低" => Product.find(params[:id].to_i).low_price}.merge(Product.find(params[:id].to_i).price_history || {})
    prices_hash = Product.find(params[:id].to_i).price_history || {}
    @chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.options[:xAxis][:categories] = prices_hash.keys #.map{ |date| date.split("-").last == "01" ? date : date.split("-").last }
      f.options[:xAxis][:tickInterval] = prices_hash.count.to_i / 8
      f.options[:xAxis][:tickWidth] = 0
      # f.options[:xAxis][:gridLineWidth] = 1
      f.options[:legend][:enabled] = false
      f.series(:type=> 'spline',:name=> '价格', :data=> prices_hash.values.map{ |v| v.to_f })
    end
  end


  def get_info
    @product = Product.find(params[:id].to_i)
  end
end
