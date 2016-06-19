class IndexController < ApplicationController
  before_action :wx_auth!, only: [:test]

  def index
    @bargains = Bargain
    @bargains = Bargain.search(params[:search]).result if (params[:search] || {})[:product_name_cont].present?
    @bargains = @bargains.where("discount >= '#{1 - params[:discount].to_f / 10 }'") if params[:discount].present?
    @bargains = @bargains.where("category_ids LIKE ?", ",#{params[:category]}") if params[:category].present?
    @bargains = @bargains.order("created_at desc").includes(:product)
    total_entries = @bargains.count > 500 ? 500 : @bargains.count
    @bargains = @bargains.paginate(page: params[:page], per_page: 50, total_entries: total_entries)
  end

  def test

  end
end
