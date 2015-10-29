class Admin::WelcomeController < Admin::BaseController
  
  def index
    @bargains = Bargain.order("created_at desc").includes(:product).paginate(page: params[:page])
  end
end
