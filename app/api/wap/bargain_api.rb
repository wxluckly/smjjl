class Wap::BargainApi < Grape::API

  resource :bargains, desc: '' do
    # 只捕捉本路由中的404
    rescue_from ActiveRecord::RecordNotFound do |e|
      error_response(message: {error: '内容不存在'}, status: 404)
    end

    desc '优惠内容，默认为20条' do
      failure [[401, '未授权']]
    end
    params do
      requires :per, type: Integer, desc: "个数"
      optional :created_at, type: String, desc: "时间(传送时，返回小于该时间发布的内容)"
    end
    get '/welcome' do
      if params[:created_at]
        present Bargain.order("created_at desc, id desc").where('created_at < ?', Time.parse(params[:created_at])).includes(:product).limit(params[:per] || 20), with: Wap::Entities::Bargains
      else
        present Bargain.order("created_at desc, id desc").includes(:product).limit(params[:per] || 20), with: Wap::Entities::Bargains
      end
    end

    desc '取最新优惠内容' do
      failure [[401, '未授权']]
    end
    params do
      requires :created_at, type: String, desc: "时间(传送时，返回大于该时间发布的内容)"
    end
    get '/welcome_new' do
      present Bargain.where('created_at > ?', Time.parse(params[:created_at])).order("created_at desc, id desc").limit(100).includes(:product), with: Wap::Entities::Bargains
    end
  end
end