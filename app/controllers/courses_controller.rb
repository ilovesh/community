class CoursesController < ApplicationController
  def index
    @tags = Course.tag_counts_on(:tags).order('count desc').map(&:name)[0...25] 
    status = params[:status]
    if status == "upcoming" || status == "ongoing" || status == "finished" || status == "rolling"
      courses = Course.of_status(status.to_sym)
    else
      courses = Course.all
    end
    @courses = courses.paginate(page: params[:page])
  end

  def tagged
    @tags = Course.tag_counts_on(:tags).order('count desc').map(&:name)[0...25]
    tagged_courses = Course.tagged_with(params[:tag])
    status = params[:status]
    courses = []
    if status == "upcoming" || status == "ongoing" || status == "finished" || status == "rolling"
      courses = tagged_courses.select { |course| course.status == status.to_sym }
    else
      courses = tagged_courses
    end  
    @courses = courses.paginate(page: params[:page])      
  end

  def show
    @course   = Course.find(params[:id])
    @notes    = @course.notes
    @notes_by_date = @notes[0..2]
    @notes_by_like = @notes. sort_by { |n| -n.likes.count }[0..2]
    @reviews = @course.reviews
    @reviews_by_date = @reviews.limit(10)
    @reviews_by_vote = @reviews.sort_by { |r| -r.likes.count }[0..9]
    @top_tags = @course.top_tags[0..9]
    @enrollments = @course.enrollments[0..8]
    @lists = List.has(@course)[0..5]
  end
end
