class BasicsController < ApplicationController
  def home
    @popular_ongoing_courses = Course.of_status(:ongoing).sort_by{ |c| -c.taking_users.count }[0..4]
    @popular_upcoming_courses = Course.of_status(:upcoming).sort_by{ |c| -c.will_take_users.count }[0..4]
    @popular_finished_courses = Course.of_status(:finished).sort_by{ |c| -c.taken_users.count }[0..4]
    @discussions = Discussion.all(limit: 5)
    @lists       = List.all(limit: 5)
  end

  def search
  	query = params[:course_name]
  	@courses = Course.search_by_full_name(query).paginate(page: params[:page])
  end
end