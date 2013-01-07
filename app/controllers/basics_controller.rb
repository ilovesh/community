class BasicsController < ApplicationController
  def home
    @ongoing = Course.of_status(:ongoing).sort_by{ |c| -c.users.count }[0..20].sample(6)
    @upcoming = Course.of_status(:upcoming).sort_by{ |c| -c.users.count }[0..20].sample(6)
    #tag_list = Course.tag_counts_on(:tags).order('count desc').map(&:name)
    #tags = tag_list[0..4]
    #tags = ["et", "qui", "est", "similique"]
    @et = Course.tagged_with("et").sort_by {|c| -c.users.count }[0..5]
    @qui = Course.tagged_with("qui").sort_by {|c| -c.users.count }[0..5]
    @est = Course.tagged_with("est").sort_by {|c| -c.users.count }[0..5]
    @similique = Course.tagged_with("similique").sort_by {|c| -c.users.count }[0..5]
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
end