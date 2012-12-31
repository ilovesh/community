class LikesController < ApplicationController
  before_filter :loggedin_user, only: [:create, :destroy]

  def create
    likeable_type = params[:like][:likeable_type]
    @likeable = likeable_type.constantize.find(params[:like][:likeable_id])
    current_user.like!(@likeable)
    if likeable_type == "Note"
      @icon_name = "star"
    elsif likeable_type == "Review"
      @icon_name = "chevron-down"
    end
    respond_to do |format|
      format.html { redirect_to root_url }
      format.js
    end
  end

  def destroy
    @like = Like.find(params[:id])
    likeable_type = @like.likeable_type
    if likeable_type == "Note"
      @icon_name = "star-empty"
    elsif likeable_type == "Review"
      @icon_name = "chevron-up"
    end
    @like.destroy
    respond_to do |format|
      format.html { redirect_to root_url }
      format.js
    end    
  end
end