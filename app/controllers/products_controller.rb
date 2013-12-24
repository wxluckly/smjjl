class ProductsController < ApplicationController
  def show
    @product = Product.find(params[:id].to_i)
    # prices_array = @product.prices
    # @chart = LazyHighCharts::HighChart.new('graph') do |f|
    # f.title({ :text=>"价格走势"})
    # f.options[:xAxis][:categories] = prices_array.map(&:created_at)
    # f.series(:type=> 'spline',:name=> '价格', :data=> prices_array.map{|p|p.value.to_i})
  end
  end
end
