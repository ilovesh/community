class BasicsController < ApplicationController
  def home
    @popular_ongoing_courses = Course.ongoing.sort_by{ |c| -c.taking_users.count }[0..4]
    @popular_upcoming_courses = Course.upcoming.sort_by{ |c| -c.will_take_users.count }[0..4]
    @popular_finished_courses = Course.finished.sort_by{ |c| -c.taken_users.count }[0..4]
    @discussions = Discussion.all(limit: 5)
    @lists       = List.all(limit: 5)
  end

  def search
  	query = params[:q]
  	@courses = Course.search(query).paginate(page: params[:page])
  end
end