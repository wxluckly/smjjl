class IndexController < ApplicationController
  def index
    @bargains = Bargain.order("created_at desc").includes(:product).paginate(page: params[:page])
  end
end
