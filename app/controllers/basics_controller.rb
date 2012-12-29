class BasicsController < ApplicationController
  def home
    @ongoing = Course.of_status(:ongoing).sort_by{ |c| -c.taking_users.count }[0..20].sample(6)
    @upcoming = Course.of_status(:upcoming).sort_by{ |c| -c.interested_users.count }[0..20].sample(6)
    #tag_list = Enrollment.tag_counts_on(:tags).order('count desc').map(&:name)
    #tags = tag_list[0..4]
    #tags = ["et", "ut", "aut", "voluptatem", "qui"]
    @et = Course.tagged_with("et").sort_by {|c| -c.users.count }[0..5]
    @ut = Course.tagged_with("ut").sort_by {|c| -c.users.count }[0..5]
    @aut = Course.tagged_with("aut").sort_by {|c| -c.users.count }[0..5]
    @voluptatem = Course.tagged_with("voluptatem").sort_by {|c| -c.users.count }[0..5]
    @qui = Course.tagged_with("qui").sort_by {|c| -c.users.count }[0..5]
    @discussions = Discussion.all(limit: 3)
    @lists       = List.non_empty[0..5]

  end

  def search
  	query = params[:course_name]
  	@courses = Course.search_by_full_name(query).paginate(page: params[:page])
  end
end