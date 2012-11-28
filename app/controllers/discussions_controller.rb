class DiscussionsController < ApplicationController
  before_filter :loggedin_user, only: [:new, :create, :destroy]
  before_filter :correct_user,  only: :destroy

  def new
    @discussion = Discussion.new
  end

  def create
    @discussion = current_user.discussions.build(params[:discussion])
    if @discussion.save
      flash[:success] = "Discussion created!"
      redirect_to @discussion
    else
      render 'new'
    end
  end

  def show
    @discussion = Discussion.find(params[:id])
    @comments   = Comment.find_comments_for_commentable("Discussion", @discussion.id)
  end

  def edit
    @discussion = Discussion.find(params[:id])
  end

  def update
    @discussion = Discussion.find(params[:id])
    if @discussion.update_attributes(params[:discussion])
      flash[:success] = "Discussion updated"
      redirect_to @discussion
    else
      render 'edit'
    end
  end

  def index
    @discussions = Discussion.paginate(page: params[:page])
  end

  def destroy
    @discussion.destroy
    redirect_to discussions_path
  end

private
  def correct_user
    @discussion = current_user.discussions.find_by_id(params[:id])
    redirect_to root_path if @discussion.nil?
  end

end