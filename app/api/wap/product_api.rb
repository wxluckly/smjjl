class Wap::ProductApi < Grape::API

  resource :products, desc: '' do
    # 只捕捉本路由中的404
    rescue_from ActiveRecord::RecordNotFound do |e|
      error_response(message: {error: '内容不存在'}, status: 404)
    end

    # ...........................................................................
    desc '优惠内容，默认为20条' do
      failure [[401, '未授权']]
    end
    params do
      requires :id, type: Integer, desc: "ID"
    end
    get '/show' do
      present Product.find(params[:id]), with: Wap::Entities::Product
    end

  end
end