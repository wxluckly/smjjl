class SitemapController < ApplicationController
  def index
    @products = Product.select("id, name, created_at").order("id desc").paginate(page: params[:page])
  end
end
