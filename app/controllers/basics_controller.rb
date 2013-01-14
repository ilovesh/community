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
    @admin = User.find_by_email("j@courigin.com")
    @suggestion_discussion = @admin.discussions.last if @admin.discussions.any?
    @taken_list = @admin.lists.last if @admin.lists.any?
  end

  def search
  	query = params[:q]
    @tags = Course.tag_counts_on(:tags).order('count desc').map(&:name)[0...25] 
    courses = Course.search_by_full_name(query)
    status = params[:status]
    @courses = []
    if status && (status == 'upcoming' || status == 'ongoing' || status = 'finished' || status = 'rolling')
      courses.each { |c| @courses << c if c.status == status.to_sym }
      Session.all.each do |s|
        if !@courses.include?(s.course) && courses.include?(s.course) && s.status == status.to_sym
          @courses << s.course
        end
      end
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