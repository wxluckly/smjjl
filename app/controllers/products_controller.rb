class ProductsController < ApplicationController
  def show
    @product = Product.find_by(id: params[:id])
    redirect_to '/' unless @product
  end
end
