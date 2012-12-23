class CommentsController < ApplicationController
  before_filter :loggedin_user, only: [:new, :create, :destroy]
  before_filter :correct_user,  only: :destroy

  def create
    # constantize converts String to Model name
    @commentable = params[:comment][:commentable_type].constantize.find(params[:comment][:commentable_id])
  	@comment     = current_user.comment!(@commentable, params[:comment][:body])
    if @comment.save
      flash[:success] = "Comment created!"
      redirect_to @commentable
    else
      render 'new'
    end
  end

  def destroy
  	@commentable = @comment.commentable
    if @comment.destroy
      redirect_to @commentable
    end
  end

private
  def correct_user
    @comment = current_user.comments.find_by_id(params[:id])
    redirect_to root_url if @comment.nil?
  end
end
