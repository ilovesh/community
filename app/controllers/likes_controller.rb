class LikesController < ApplicationController
  before_filter :loggedin_user, only: [:create]
  before_filter :correct_user,  only: [:destroy]

  def create
    likeable_type = params[:like][:likeable_type]
    @likeable = likeable_type.constantize.find(params[:like][:likeable_id])
    @like = current_user.like!(@likeable)
    if likeable_type == "Note" || likeable_type == "List"
      @icon_name = LIKED
    elsif likeable_type == "Review" || likeable_type == "Discussion" || likeable_type == "Comment"
      @icon_name = VOTED
    end
    @likeable.user.add_notification!(@likeable, @like, current_user)
    respond_to do |format|
      format.html { redirect_to @likeable }
      format.js
    end
  end

  def destroy
    likeable_type = @like.likeable_type
    @likeable = likeable_type.constantize.find(@like.likeable_id)
    if likeable_type == "Note" || likeable_type == "List"
      @icon_name = LIKE
    elsif likeable_type == "Review" || likeable_type == "Discussion" || likeable_type == "Comment"
      @icon_name = VOTE_UP
    end
    @like.destroy
    respond_to do |format|
      format.html { redirect_to @likeable }
      format.js
    end    
  end

private
  def correct_user
    @like = current_user.likes.find_by_id(params[:id])
    redirect_to root_path if @like.nil?
  end

end