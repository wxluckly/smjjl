class Users::SessionsController < Devise::SessionsController
# before_filter :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    user = User.find_by(email: params[:user][:logname])
    user = User.find_by(username: params[:user][:logname]) unless user
    if user && user.valid_password?(params[:user][:password])
      sign_in_and_redirect user, event: :authentication, notice: ""
    else
      redirect_to user_session_path, notice: '用户名或密码错误'
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # You can put the params you want to permit in the empty array.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.for(:sign_in) << :attribute
  # end
end
