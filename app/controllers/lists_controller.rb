class ListsController < ApplicationController
  before_filter :loggedin_user, only: [:new, :create, :destroy]
  before_filter :correct_user,  only: :destroy

  def new
    @list = List.new
  end

  def create
  	@list = current_user.lists.build(params[:list])
    if @list.save
      flash[:success] = "List created!"
      redirect_to @list
    else
      render 'new'
    end
  end

  def show
    @list     = List.find(params[:id])
    @comments = Comment.find_comments_for_commentable("List", @list.id)
  end

  def edit
    @list = List.find(params[:id])
  end

  def update
    @list = List.find(params[:id])
    if @list .update_attributes(params[:list])
      flash[:success] = "List updated"
      redirect_to @list
    else
      render 'edit'
    end
  end

  def index
    @lists = List.paginate(page: params[:page])
  end

  def destroy
    @list.destroy
    redirect_to lists_path
  end

private
  def correct_user
    @list = current_user.lists.find_by_id(params[:id])
    redirect_to root_path if @list.nil?
  end

end
