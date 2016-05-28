class Admin::BaseController < ApplicationController
  before_filter :authenticate_staffer!
  before_filter :check_role
  layout 'admin'

  def check_role
    unless current_staffer.category == 'admin'
      redirect_to "http://smjjl.com" and return
    end
  end
end
