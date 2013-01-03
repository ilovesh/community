class DiscussionsController < ApplicationController
  before_filter :loggedin_user, only: [:new, :create]
  before_filter :correct_user,  only: [:destroy, :update, :edit]

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
    @comments   = @discussion.comment_threads
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
    @newest = Discussion.paginate(page: params[:newest_page])
    @votes = Discussion.all.sort_by { |d| -d.likes.count }.paginate(page: params[:votes_page])
    @comments = Discussion.all.sort_by { |d| -d.comment_threads.count }.paginate(page: params[:comments_page])  
    @tags = Discussion.tag_counts_on(:tags).order('count desc').map(&:name)[0...25]
  end

  def tagged
    @tags = Discussion.tag_counts_on(:tags).order('count desc').map(&:name)[0...25]
    @discussions = Discussion.tagged_with(params[:tag]).paginate(page: params[:page])    
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