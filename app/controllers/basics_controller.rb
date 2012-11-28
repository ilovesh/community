class BasicsController < ApplicationController
  def home
    if !logged_in?
      @popular_ongoing_courses = Course.ongoing.sort_by{ |c| -c.taking_users.count }[0..4]
      @popular_upcoming_courses = Course.upcoming.sort_by{ |c| -c.will_take_users.count }[0..4]
      @popular_finished_courses = Course.finished.sort_by{ |c| -c.taken_users.count }[0..4]
      @discussions = Discussion.all(limit: 5)
    end
  end
end