class Admin::ProductListsController < Admin::BaseController
  def index
    @product_lists = ProductList.order(id: :desc).search(params[:search]).result.paginate(page: params[:page])
  end

  def block
    product_list = ProductList.find(params[:product_list_id])
    product_list.is_blocked = true
    product_list.save
    render js: 'location.reload();'
  end

  def unblock
    product_list = ProductList.find(params[:product_list_id])
    product_list.is_blocked = false
    product_list.save
    render js: 'location.reload();'
  end
end
