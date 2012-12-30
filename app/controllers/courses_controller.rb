class CoursesController < ApplicationController
  def index
    @courses = Course.paginate(page: params[:page])
  end

  def show
    @course   = Course.find(params[:id])
    @provider = @course.provider
    @notes    = @course.notes
    @notes_by_date = @notes[0..2]
    @notes_by_like = @notes. sort_by { |n| -n.likes.count }[0..2]
    @reviews = Comment.find_comments_for_commentable("Course", @course.id)
    @reviews_by_date = @reviews.limit(10)
    @reviews_by_vote = @reviews.sort_by { |c| -c.plusminus }[0..9]
    @top_tags = @course.tag_list[0..9]
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
