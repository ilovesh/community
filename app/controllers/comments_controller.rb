class CommentsController < ApplicationController
  before_filter :loggedin_user, only: [:create]
  before_filter :correct_user, only: [:destroy]

  def create
    #@course = Course.find(params[:course_id])
    @commentable_type = params[:comment][:commentable_type]
    @commentable_id = params[:comment][:commentable_id]
    @comment = current_user.comment!(@commentable_type, @commentable_id, params[:comment][:body])
    @commentable = @comment.commentable
    @comments = @commentable.comment_threads
    if @comment.save
      respond_to do |format|
        format.html { redirect_to @commentable }
        format.js
      end
    else
      render 'new'
    end
  end

  def destroy
  	@commentable = @comment.commentable
    @commentable_type = @comment.commentable_type
    @commentable_id = @comment.commentable_id
    @comments = @commentable.comment_threads
    if @comment.destroy
      respond_to do |format|
        format.html { redirect_to @commentable }
        format.js
      end
    end
  end

private
  def correct_user
    @comment = current_user.comments.find_by_id(params[:id])
    redirect_to root_url if @comment.nil?
  end
end
