class CoursesController < ApplicationController
  def index
    @tags = Course.tag_counts_on(:tags).order('count desc').map(&:name)[0...25] 
    status = params[:status]
    if status == "upcoming" || status == "ongoing" || status == "finished" || status == "rolling"
      courses = Course.of_status(status.to_sym)
    else
      courses = Course.all
    end
    @count = courses.count
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
    @count = courses.count
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
=begin
    @related_courses = []
    tags = @course.top_tags
    if tags
      tags.each do |tag|
        tagged_courses = Course.tagged_with(tag)
        @related_courses += tagged_courses
      end
      @related_courses = @related_courses.uniq.delete_if { |d| d.id == @course.id }.sort_by(&:created_at).reverse[0..4]
    end
=end

  def interested
    @course = Course.find(params[:id])
    @users = @course.interested_users
  end

  def taking
    @course = Course.find(params[:id])
    @users = @course.taking_users
  end

  def finished
    @course = Course.find(params[:id])
    @users = @course.taken_users
  end

  end
end
