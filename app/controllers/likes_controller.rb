class LikesController < ApplicationController
  before_filter :loggedin_user, only: [:create, :destroy]

  def create
    likeable_type = params[:like][:likeable_type]
    @likeable = likeable_type.constantize.find(params[:like][:likeable_id])
    current_user.like!(@likeable)
    if likeable_type == "Note" || likeable_type == "List"
      @icon_name = LIKED
    elsif likeable_type == "Review" || likeable_type == "Discussion" || likeable_type == "Comment"
      @icon_name = VOTED
    end
    respond_to do |format|
      format.html { redirect_to root_url }
      format.js
    end
  end

  def destroy
    @like = Like.find(params[:id])
    likeable_type = @like.likeable_type
    if likeable_type == "Note" || likeable_type == "List"
      @icon_name = LIKE
    elsif likeable_type == "Review" || likeable_type == "Discussion" || likeable_type == "Comment"
      @icon_name = VOTE_UP
    end
    @like.destroy
    respond_to do |format|
      format.html { redirect_to root_url }
      format.js
    end    
  end
end