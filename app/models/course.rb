# == Schema Information
#
# Table name: courses
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  provider_id   :integer
#  progress      :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  code          :string(255)
#  image_link    :string(255)
#  description   :text
#  subtitle      :string(255)
#  instructor    :string(255)
#  prerequisites :text
#  course_url    :string(255)
#  start_date    :date
#  final_date    :date
#  duration      :string(255)
#

# progress:
# 0 - rolling; 1 - coming; 2 - ing; 3 - end

class Course < ActiveRecord::Base

  attr_accessible :name, :provider_id, :progress, :code, :image_link, 
                  :description, :subtitle, :start_date, :final_date,
                  :instructor, :prerequisites, :university, :course_url, :duration
  acts_as_commentable

  include PgSearch
  pg_search_scope :search_by_full_name, against: [:code, :name], 
                  using: {tsearch: {prefix: true}}

  validates :name,         presence: true
  validates :provider_id,  presence: true
#  validates :progress,     presence: true, inclusion: {in: (0..3)}
  validates :image_link,   presence: true
  validates :description,  presence: true
  validates :code,         allow_blank: true, uniqueness: { scope: :provider_id, case_sensitive: false }
#  validates :prerequisites, presence: true
  validates :instructor,   presence: true
  validates :course_url,   presence: true

  belongs_to :provider
  has_many   :enrollments, dependent: :destroy
  has_many   :users,       through: :enrollments
  has_many   :will_take_users, through: :enrollments,
             source: :user, conditions: ["enrollments.status = ?", 1]
  has_many   :taking_users,    through: :enrollments,
             source: :user, conditions: ["enrollments.status = ?", 2]            
  has_many   :taken_users,     through: :enrollments,
             source: :user, conditions: ["enrollments.status = ?", 3]
  has_many :listings, dependent: :destroy
  has_many :lists,    through: :listings
  has_and_belongs_to_many :universities
#  has_many :comments, dependent: :destroy

  scope :ongoing,  where("progress = ?", 2)
  scope :upcoming, where("progress = ?", 1)
  scope :finished, where("progress = ?", 3)

  def full_name
  	if code
  	  code + ' ' + name
  	else
      name
    end
  end

  def course_path
    "/courses/#{self.id}"
  end

  # return an array
  def tag_list
    Enrollment.where(course_id: id).tag_counts_on(:tags).order('count desc').map(&:name)
  end

end
