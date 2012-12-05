class CoursesController < ApplicationController
  autocomplete :name, full: true

  def index
  end

  def show
    @course   = Course.find(params[:id])
    @comments = Comment.find_comments_for_commentable("Course", @course.id)
  end

  def ongoing
    @ongoing_courses = Course.ongoing.paginate(page: params[:page])
  end

  def upcoming
    @upcoming_courses = Course.upcoming.paginate(page: params[:page])
  end

  def finished
    @finished_courses = Course.finished.paginate(page: params[:page])
  end
end
