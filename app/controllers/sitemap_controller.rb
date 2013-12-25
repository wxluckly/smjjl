class SitemapController < ApplicationController
  def index
    @products = Product.order("id desc").paginate(page: params[:page])
  end
end
