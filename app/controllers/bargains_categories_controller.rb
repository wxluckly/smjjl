class BargainsCategoriesController < ApplicationController
  def index
    @bargains_categories = BargainsCategory.where(category_id: params[:category_id]).order("created_at desc").includes([bargain: :product]).paginate(page: params[:page])
    @category = Category.find(params[:category_id])
  end
end
