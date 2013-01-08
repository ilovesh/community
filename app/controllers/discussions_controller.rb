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
    @user = @discussion.user
    @posts = @user.discussions.delete_if { |d| d.id == @discussion.id }.sort_by(&:created_at).reverse[0..4]
    @related_discussions = []
    tags = @discussion.tag_list
    if tags
      tags.each do |tag|
        tagged_discussions = Discussion.tagged_with(tag)
        @related_discussions += tagged_discussions
      end
      @related_discussions = @related_discussions.uniq.delete_if { |d| d.id == @discussion.id }.sort_by(&:created_at).reverse[0..4]
    end
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
    @tags = Discussion.tag_counts_on(:tags).order('count desc').map(&:name)[0...25]
    discussions = Discussion.all 
    if params[:tab] == "votes"
      @discussions = by_votes(discussions).paginate(page: params[:page])
    elsif params[:tab] == "comments"
      @discussions = by_comments(discussions).paginate(page: params[:page])
    else
      @discussions = discussions.paginate(page: params[:page])
    end
  end

  def tagged
    @tag = params[:tag]
    @tags = Discussion.tag_counts_on(:tags).order('count desc').map(&:name)[0...25]
    discussions = Discussion.tagged_with(@tag)
    if params[:tab] == "votes"
      @discussions = by_votes(discussions).paginate(page: params[:page])
    elsif params[:tab] == "comments"
      @discussions = by_comments(discussions).paginate(page: params[:page])
    else
      @discussions = discussions.paginate(page: params[:page])
    end  
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

  def by_votes(discussions)
    discussions.sort_by { |d| -d.likes.count }
  end
 
  def by_comments(discussions)
    discussions.sort_by { |d| -d.comment_threads.count }
  end

end