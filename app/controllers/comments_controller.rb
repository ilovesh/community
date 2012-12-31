class CommentsController < ApplicationController
  before_filter :loggedin_user, only: [:new, :create, :destroy]
  before_filter :correct_user,  only: [:edit, :update, :destroy]

  def new
    @course = Course.find(params[:course_id])
    @review = Comment.new
  end

  def create
    @course = Course.find(params[:course_id])
    @comment = current_user.comment!(@course, params[:comment][:body], params[:comment][:title])
    if @comment.save
      redirect_to @comment
    else
      render 'new'
    end
  end

  def show
    @course = Course.find(params[:course_id])
    @review = Comment.find(params[:id])
  end

  def index
    @course = Course.find(params[:course_id])
    @reviews = @course.comment_threads.paginate(page: params[:page])
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
