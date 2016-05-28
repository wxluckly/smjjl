class Admin::ProductListsController < Admin::BaseController
  def index
    @product_lists = ProductList.priored.search(params[:search]).result.paginate(page: params[:page])
  end

  def block
    product_list = ProductList.find(params[:id])
    product_list.is_blocked = true
    product_list.save
    render js: 'location.reload();'
  end

  def unblock
    product_list = ProductList.find(params[:id])
    product_list.is_blocked = false
    product_list.save
    render js: 'location.reload();'
  end

  def set_is_prior
    ProductList.find(params[:id]).update(is_prior: params[:is_prior])
    render nothing: true
  end
end
