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
    @comments = Comment.find_comments_for_commentable("List", @list.id)
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
    @lists = List.non_empty.paginate(page: params[:page])
    @tags = List.tag_counts_on(:tags).order('count desc').map(&:name)[0...25] 
  end

  def destroy
    @list.destroy
    redirect_to lists_path
  end

  def tagged
    @tags = List.tag_counts_on(:tags).order('count desc').map(&:name)[0...25]
    @lists = List.tagged_with(params[:tag]).paginate(page: params[:page])
  end

private
  def correct_user
    @list = current_user.lists.find_by_id(params[:id])
    redirect_to root_path if @list.nil?
  end

end
