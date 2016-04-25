class IndexController < ApplicationController
  before_action :wx_auth!, only: [:test]

  def index
    @bargains = Bargain.order("created_at desc").includes(:product).limit(100)
    render layout: false
  end

  def test

  end
end
