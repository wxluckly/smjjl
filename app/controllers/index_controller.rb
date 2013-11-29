class IndexController < ApplicationController
  def index
    @bargains = Bargain.order("id desc").includes(:product).paginate(page: params[:page])
  end
end
