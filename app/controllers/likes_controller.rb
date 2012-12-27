class LikesController < ApplicationController
  before_filter :loggedin_user, only: [:create, :destroy]

  def create
    @like = current_user.likes.create!(like: true,
    	                               likeable_type: params[:like][:likeable_type],
    	                               likeable_id: params[:like][:likeable_id])
    @like.save
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