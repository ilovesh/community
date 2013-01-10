class NotificationsController < ApplicationController
  before_filter :correct_user,   only: [:index]

  def index
    @notifications = current_user.unread_notifications
  end

private
  def correct_user
    @user = User.find(params[:user_id])
    redirect_to(root_path) unless current_user?(@user)
  end


end