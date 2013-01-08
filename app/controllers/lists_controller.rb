class ListsController < ApplicationController
  before_filter :loggedin_user, only: [:new, :create]
  before_filter :correct_user,  only: [:destroy, :update, :edit]

  respond_to :html, :json

  def new
    @list = List.new
  end

  def create
  	@list = current_user.lists.build(params[:list])
    if @list.save
      redirect_to @list
    else
      render 'new'
    end
  end

  def show
    @list     = List.find(params[:id])
    @courses = @list.courses.sort_by {|c| Listing.find_by_list_id_and_course_id(@list.id, c.id).created_at }
    @comments = @list.comment_threads[0..2]
    @user = @list.user
    @lists = @user.lists.non_empty.delete_if { |l| l.id == @list.id }.sort_by(&:created_at).reverse[0..2]
    @related_lists = []
    tags = @list.tag_list
    if tags
      tags.each do |tag|
        tagged_lists = List.tagged_with(tag)
        @related_lists += tagged_lists
      end
      @related_lists = @related_lists.uniq.delete_if { |l| l.id == @list.id }.sort_by(&:created_at).reverse[0..2]
    end    
  end

  def edit
    @list = List.find(params[:id])
  end

  def update
    @list = List.find(params[:id])
    if @list .update_attributes(params[:list])
      flash[:success] = "List updated"
      respond_with @list
    else
      render 'edit'
    end
  end

  def index
    @tags = List.tag_counts_on(:tags).order('count desc').map(&:name)[0...25]
    lists = List.non_empty
    if params[:tab] == "stars"
      @lists =  by_stars(lists).paginate(page: params[:page])
    else
      @lists = lists.paginate(page: params[:page])
    end
  end

  def destroy
    @list.destroy
    redirect_to lists_path
  end

  def tagged
    @tag = params[:tag]
    @tags = List.tag_counts_on(:tags).order('count desc').map(&:name)[0...25]
    lists = List.tagged_with(params[:tag]).non_empty
    if params[:tab] == "stars"
      @lists = by_stars(lists).paginate(page: params[:page])
    else
      @lists = lists.paginate(page: params[:page])
    end
  end

private
  def correct_user
    @list = current_user.lists.find_by_id(params[:id])
    redirect_to root_path if @list.nil?
  end

  def by_stars(lists)
    lists.sort_by { |l| -l.likes.count }
  end
end
