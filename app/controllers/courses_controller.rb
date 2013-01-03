class CoursesController < ApplicationController
  def index
    @tags = Enrollment.tag_counts_on(:tags).order('count desc').map(&:name)[0...25] 
    if params[:status] == "upcoming"
      @courses = Course.of_status(:upcoming).paginate(page: params[:page])
      @title = params[:status].capitalize
    elsif params[:status] == "ongoing"
      @courses = Course.of_status(:ongoing).paginate(page: params[:page])
      @title = params[:status].capitalize
    elsif params[:status] == "finished"
      @courses = Course.of_status(:finished).paginate(page: params[:page])
      @title = params[:status].capitalize
    elsif params[:status] == "rolling"
      @courses = Course.of_status(:rolling).paginate(page: params[:page])
      @title = params[:status].capitalize
    elsif params[:status] == "all"
      redirect_to courses_path
    else
      @courses = Course.paginate(page: params[:page])
    end
  end

  def tagged
    @tags = Enrollment.tag_counts_on(:tags).order('count desc').map(&:name)[0...25]
    tagged_courses = Course.tagged_with(params[:tag])
    status = params[:status]
    @courses = []
    if status == "upcoming" || status == "ongoing" || status == "finished" || status == "rolling"
      courses = tagged_courses.select { |course| course.status == status.to_sym }
    else
      courses = tagged_courses
    end 
    if params[:status] == "upcoming"
      courses.each { |c| @courses << c if c.status == :upcoming }
    elsif params[:status] == "ongoing"
      courses.each { |c| @courses << c if c.status == :ongoing }
    elsif params[:status] == "finished"
      courses.each { |c| @courses << c if c.status == :finished }    
    elsif params[:status] == "rolling"
      courses.each { |c| @courses << c if c.status == :rolling }
    else
      @courses = courses
    end  
    @courses = @courses.paginate(page: params[:page])      
  end

  def show
    @course   = Course.find(params[:id])
    @notes    = @course.notes
    @notes_by_date = @notes[0..2]
    @notes_by_like = @notes. sort_by { |n| -n.likes.count }[0..2]
    @reviews = @course.reviews
    @reviews_by_date = @reviews.limit(10)
    @reviews_by_vote = @reviews.sort_by { |r| -r.likes.count }[0..9]
    @top_tags = @course.tag_list[0..9]
  end
end
