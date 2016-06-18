class IndexController < ApplicationController
  before_action :wx_auth!, only: [:test]

  def index
    if (params[:search] || {})[:product_name_cont].present?
      @bargains = Bargain.search(params[:search]).result
      @bargains = @bargains.where("discount >= '#{1 - params[:discount].to_f / 10 }'") if params[:discount].present?
      @bargains = @bargains.order("created_at desc").includes(:product).paginate(page: params[:page], per_page: 50, total_entries: 50)
    elsif params[:discount].present?
      if params[:category].present?
        bargains_categories = BargainsCategory.where(category_id: params[:category]).includes([bargain: :product])
        @bargains = bargains_categories.where("bargains.discount >= '#{1 - params[:discount].to_f / 10 }'").order("created_at desc").includes(:product).paginate(page: params[:page], per_page: 50, total_entries: 500)
      else
        @bargains = Bargain.where("discount >= '#{1 - params[:discount].to_f / 10 }'").order("created_at desc").includes(:product).paginate(page: params[:page], per_page: 50, total_entries: 500)
      end
    else
      @bargains = Bargain.order("created_at desc").includes(:product).paginate(page: params[:page], per_page: 50, total_entries: 500)
    end
  end

  def test

  end
end
