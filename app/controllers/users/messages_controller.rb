class Users::MessagesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @messages = current_user.messages.ask
    @message = Message.new
  end

  def create
    current_user.messages.create(category: 0, content: params[:message][:content])
  end
end
