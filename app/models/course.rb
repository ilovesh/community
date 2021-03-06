# == Schema Information
#
# Table name: courses
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  provider_id   :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  code          :string(255)
#  image_link    :string(255)
#  description   :text
#  subtitle      :string(255)
#  instructor    :string(255)
#  prerequisites :text
#  url           :string(255)
#  start_date    :datetime
#  final_date    :datetime
#  duration      :integer
#  multi         :boolean          default(FALSE)
#

# duration(week):
# 0 - rolling; 99 - N/A(upcoming); 50 - N/A with specific start_date
# start_date.nil? && duration == 0  => Udacity rolling
# start_date.nil? && (duration.nil? || duration != 0)  => Coursera upcoming


class Course < ActiveRecord::Base
  attr_accessible :name, :code, :image_link, :url, 
                  :description, :subtitle, :start_date, :final_date,
                  :instructor, :prerequisites, :duration, :tag_list, :multi

  include PgSearch
  pg_search_scope :search_by_full_name, against: [:code, :name], 
                  using: {tsearch: {prefix: true}}

  validates :name,         presence: true
  #validates :code,         allow_blank: true, uniqueness: { scope: :provider_id, case_sensitive: false }
  validates :image_link,   presence: true
  validates :url,          presence: true
  validates :description,  presence: true
  validates :instructor,   presence: true

  belongs_to :provider
  has_many   :enrollments, dependent: :destroy
  has_many   :users,       through: :enrollments
  has_many   :interested_users, through: :enrollments,
             source: :user, conditions: ["enrollments.status = ?", 1]
  has_many   :taking_users,    through: :enrollments,
             source: :user, conditions: ["enrollments.status = ?", 2]            
  has_many   :taken_users,     through: :enrollments,
             source: :user, conditions: ["enrollments.status = ?", 3]
  has_many :listings, dependent: :destroy
  has_many :lists,    through: :listings
  has_many :teachings, dependent: :destroy
  has_many :universities,    through: :teachings
  has_many :notes, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :sessions, dependent: :destroy

  default_scope order: 'courses.start_date DESC'
  scope :of_status, lambda{ |status| all.select{ |course| course.status == status.to_sym } }

  def full_name
    full_name = code.nil? ? name : code + ' ' + name
  end

  def course_path
    "/courses/#{self.id}"
  end

  # return an array
  def top_tags
    Enrollment.where(course_id: id).tag_counts_on(:tags).order('count desc').map(&:name)
  end

  def self.tag_list
    all_tags = []
    Course.all.each do |c|
      all_tags += c.top_tags
    end
    freq = all_tags.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
    all_tags.sort_by { |v| -freq[v] }.uniq
  end

  def self.tagged_with(tag)
    courses = []
    Course.all.each do |c|
      courses << c if c.top_tags.include? tag
    end
    courses
  end

  def status
    time = Time.now.utc
    start_date = self.start_date
    final_date = self.final_date
    duration   = self.duration
    if start_date
      if final_date.nil? && duration
        final_date = start_date + duration.weeks + 23.hour + 59.minute + 59.second
      end
      return :upcoming if start_date > time
      return :ongoing  if final_date && time > start_date && time < final_date
      return :self_paced  if final_date.nil? && time > start_date # in case of such a weird situation
      return :finished
    else
      return :self_paced if duration == 0
      return :upcoming
    end
  end

end
