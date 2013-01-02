class ListingsController < ApplicationController
  before_filter :loggedin_user, only: [:create]
  before_filter :correct_user, only: [:update, :destroy]

  def create
  	@course = Course.find(params[:course_id])
  	@list = List.find(params[:list_id])
  	@comment = params[:course_comment].strip() if params[:course_comment] != ""
    if @list.add!(@course, @comment)
      redirect_to @list
    else
      flash[:error] = "You have already added this course to the list."
    end
  end

  def update
    @listing.update_attributes(params[:listing])
    redirect_to @listing.list
  end

  def destroy
    @listing.destroy
    respond_with @listing.list
  end

private
  def correct_user
    @listing = Listing.find_by_id(params[:id])
    redirect_to root_url if @listing.nil?
  end  
end
