class Users::AppliesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_apply, only: [:edit, :update]

  def index
  end

  def history
    @applies = current_user.applies.order(id: :desc)
  end

  def edit
  end

  def update
    if @apply.update(apply_params.merge(match_item: (params[:apply][:match_item].join(',') rescue ''), match_team: (params[:apply][:match_team].join(',') rescue '')))
      redirect_to '/users/applies/history'
      cookies.signed[:apply_updated] = true
    else
      render 'edit'
    end
  end

  def new
    @apply = current_user.applies.new
    if params[:category].to_i == 1
      render 'new_team'
    else
      render 'new_single'
    end
  end

  def create
    apply = current_user.applies.new(apply_params.merge(match_item: (params[:apply][:match_item].join(',') rescue ''), match_team: (params[:apply][:match_team].join(',') rescue '')))
    if apply.save
      redirect_to '/users/applies/history'
      cookies.signed[:applyed] = true
    else
      redirect_to :back
    end
  end

  private
  def set_apply
    @apply = current_user.applies.find(params[:id])
  end

  def apply_params
    params.require(:apply).permit(:user_id, :category, :age_group, :match_type, :name, :gender, :age, :nationality, :city, :representing, :certificate_kind, :certificate_no, :address, :post_code, :phone, :match_team, :email, :match_item, :partner_name, :leg, :attachment, :match_name, :time, :location, :leader, :coach, :id_card, :health_info, :money_info)
  end
end
