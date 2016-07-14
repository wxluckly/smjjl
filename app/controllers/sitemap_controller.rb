class SitemapController < ApplicationController
  def index
    page = params[:page].to_i > 200 ? 200 : params[:page]
    @products = Product.where.not(name: nil).select("id, name, created_at").order("id desc").paginate(page: page, per_page: 50, total_entries: 10000 )
  end
end
