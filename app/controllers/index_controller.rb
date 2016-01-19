class IndexController < ApplicationController
  before_action :wx_auth!, only: [:test]

  def index
    @bargains = Bargain.order("created_at desc").includes(:product).paginate(page: params[:page])
  end

  def test

  end
end
