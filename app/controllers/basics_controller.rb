class BasicsController < ApplicationController
  before_filter :loggedin_user, only: [:count]

  def home
    @ongoing = Course.of_status(:ongoing).sort_by{ |c| -c.users.count }[0..20].sample(6)
    @upcoming = Course.of_status(:upcoming).sort_by{ |c| -c.users.count }[0..20].sample(6)
    tag_list = Course.tag_counts_on(:tags).order('count desc').map(&:name)
    tags = tag_list[0..4]
    @first_tag = tags[0]
    @first_tag_courses = top_tag_courses(@first_tag)
    @second_tag = tags[1]
    @second_tag_courses = top_tag_courses(@second_tag)
    @third_tag = tags[2]
    @third_tag_courses = top_tag_courses(@third_tag)
    @fourth_tag = tags[3]
    @fourth_tag_courses = top_tag_courses(@fourth_tag)
    @discussions = Discussion.all(limit: 3)
    @lists       = List.non_empty[0..5]
  end

  def search
  	query = params[:q]
    @tags = Course.tag_counts_on(:tags).order('count desc').map(&:name)[0...25] 
    courses = Course.search_by_full_name(query)
    status = params[:status]
    @courses = []
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

  def read
    current_user.unread_notifications.each {|n| n.toggle! :read }
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end 
  end

private
  def top_tag_courses(tag)
    Course.tagged_with(tag).sort_by {|c| -c.users.count }[0..5]
  end

end