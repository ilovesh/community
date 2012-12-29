class LikesController < ApplicationController
  before_filter :loggedin_user, only: [:create, :destroy]

  def create
    @likeable = params[:like][:likeable_type].constantize.find(params[:like][:likeable_id])
    current_user.like!(@likeable)
    respond_to do |format|
      format.html { redirect_to root_url }
      format.js
    end
  end

  def destroy
    @like = Like.find(params[:id])
    @like.destroy
    respond_to do |format|
      format.html { redirect_to root_url }
      format.js
    end    
  end
end