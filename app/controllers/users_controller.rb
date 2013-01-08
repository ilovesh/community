class UsersController < ApplicationController
  before_filter :logged_in_user, only: [:create] 
  before_filter :correct_user,   only: [:edit, :update]

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(params[:user])
  	if @user.save
      log_in @user
  		flash[:success] = "Welcome to #{NAME}!"
  		redirect_to root_path
    else
    	render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    params[:user].delete(:password) if params[:user][:password].blank?
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      log_in @user
      redirect_to @user      
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to root_path
  end

  def show
    @user = User.find(params[:id])
    @liked_notes = @user.likes.where("likeable_type = 'Note'").map(&:likeable)
    @liked_reviews = @user.likes.where("likeable_type = 'Review'").map(&:likeable)
    @liked_discussions = @user.likes.where("likeable_type = 'Discussion'").map(&:likeable)
    @liked_comments = @user.likes.where("likeable_type = 'Comment'").map(&:likeable)
    @liked_lists = @user.likes.where("likeable_type = 'List'").map(&:likeable)
    @enrollments = @user.enrollments
  end

private
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

end