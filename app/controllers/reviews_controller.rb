class ReviewsController < ApplicationController
  before_filter :loggedin_user, only: [:new, :create]
  before_filter :correct_user,  only: [:edit, :update, :destroy]

  def new
  	@course = Course.find(params[:course_id])
    @review = Review.new
  end

  def create
  	@course = Course.find(params[:course_id])
    @review = @current_user.review!(@course, params[:review][:body], params[:review][:title])
    if @review.save
      redirect_to @review
    else
      render 'new'
    end
  end

  def index
    @course = Course.find(params[:course_id])
    @reviews = @course.reviews.paginate(page: params[:page])
  end

  def show
    @review = Review.find(params[:id])
    @course = @review.course
  end

  def edit
  	@course = @review.course
  end

  def update
    if @review.update_attributes(params[:review])
      flash[:success] = "review updated"
      redirect_to @review
    else
      render 'edit'
    end
  end

  def destroy
  	@course = @review.course
  	@review.destroy
  	redirect_to @course
  end

private
  def correct_user
    @review = current_user.reviews.find_by_id(params[:id])
    redirect_to root_url if @review.nil?
  end  
end
