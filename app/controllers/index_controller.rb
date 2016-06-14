class IndexController < ApplicationController
  before_action :wx_auth!, only: [:test]

  def index
    # if (params[:search] || {})[:product_name_cont].present?
    #   @bargains = Bargain.where('bargains.created_at < ?', Time.now - 10.days).search(params[:search]).result
    #   @bargains = @bargains.where("discount >= '#{1 - params[:discount].to_f / 10 }'") if params[:discount].present?
    #   @bargains = @bargains.order("created_at desc").includes(:product).paginate(page: params[:page], per_page: 50, total_entries: 50)
    # els
    if params[:discount].present?
      @bargains = Bargain.where("discount >= '#{1 - params[:discount].to_f / 10 }'").order("created_at desc").includes(:product).paginate(page: params[:page], per_page: 50, total_entries: 500)
    else
      @bargains = Bargain.order("created_at desc").includes(:product).paginate(page: params[:page], per_page: 50, total_entries: 500)
    end
  end

  def test

  end
end
