class CoursesController < ApplicationController
  def index
  end

  def show
    @course   = Course.find(params[:id])
    @comments = Comment.find_comments_for_commentable("Course", @course.id)
  end

  def ongoing
    @ongoing_courses = Course.of_status(:ongoing).paginate(page: params[:page])
  end

  def upcoming
    @upcoming_courses = Course.of_status(:upcoming).paginate(page: params[:page])
  end

  def finished
    @finished_courses = Course.of_status(:finished).paginate(page: params[:page])
  end
end
