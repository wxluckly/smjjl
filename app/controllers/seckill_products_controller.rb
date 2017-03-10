class SeckillProductsController < ApplicationController

  def index
    @seckill_products = SeckillProduct
    @seckill_products = SeckillProduct.search(params[:search]).result if (params[:search] || {})[:product_name_cont].present?
    # @bargains = @bargains.where("discount >= '#{1 - params[:discount].to_f / 10 }'") if params[:discount].present?
    # @bargains = @bargains.where("category_ids LIKE ?", ",#{params[:category]}") if params[:category].present?
    @seckill_products = @seckill_products.order("created_at desc").includes(:product)
    total_entries = @seckill_products.count > 500 ? 500 : @seckill_products.count
    @seckill_products = @seckill_products.paginate(page: params[:page], per_page: 50, total_entries: total_entries)
  end
end
