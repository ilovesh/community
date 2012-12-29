# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string(255)
#  password_digest :string(255)
#  username        :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  remember_token  :string(255)
#

class User < ActiveRecord::Base
  attr_accessible :email, :username, :password
  has_secure_password
  acts_as_tagger

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  validates :username, presence: true, length: { maximum: 50 },
                       uniqueness: { case_sensitive: false }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
  					uniqueness: { case_sensitive: false }
  validates :password,  length: { minimum: 6 }

  has_many :enrollments, dependent: :destroy
  has_many :will_take_courses, through: :enrollments,
           source: :course,    conditions: ["enrollments.status = ?", 1]
  has_many :taking_courses,    through: :enrollments,
           source: :course,    conditions: ["enrollments.status = ?", 2]
  has_many :taken_courses,     through: :enrollments,
           source: :course,    conditions: ["enrollments.status = ?", 3]
  has_many :discussions,    dependent: :destroy
  has_many :lists,          dependent: :destroy
  has_many :comments,       dependent: :destroy
  has_many :votes,          dependent: :destroy
  has_many :notes,          dependent: :destroy
  has_many :likes,          dependent: :destroy

  def enroll!(course, status, *arg)
    tag_list = arg[0] if arg
    enrollments.create!(course_id: course.id,
                        status:    status,
                        tag_list:  tag_list)
  end

  def unenroll!(course)
    enrollments.find_by_course_id(course.id).destroy
  end

  def enroll?(course)
    !enrollments.find_by_course_id(course.id).nil?
  end

  def my_tags(course)
    enrollment = enrollments.find_by_course_id(course.id)
    enrollment.tag_list.to_s if enrollment
  end

  def status(course)
    enrollment = enrollments.find_by_course_id(course.id)
    enrollment.status if enrollment
  end

  def comment!(commentable, content)
    Comment.build_from(commentable, id, content)
  end

  def vote!(vote, voteable_type, voteable_id)
    unless voteable_type.constantize.find(voteable_id).nil?
      if vote
        vote_for!(voteable_type, voteable_id)
      else
        vote_against!(voteable_type, voteable_id)
      end
    end
  end

  def vote_for?(voteable)
    v = find_vote(voteable)
    v && v.vote
  end

  def vote_against?(voteable)
    v = find_vote(voteable)
    if v
      !v.vote
    else
      false
    end
  end

  def unvote!(voteable)
    vote = find_vote(voteable)
    if vote
      vote.destroy
    end
  end

  def take_note!(course, body, *arg)
    title = arg[0] if arg
    notes.create!(course_id: course.id,
                  body:      body,
                  title:     title)
  end

  def like!(likeable)
    likes.create!(like: true,
                  likeable_type: likeable.class.name,
                  likeable_id: likeable.id)
  end

  def like?(likeable_type, likeable_id)
    likes.find_by_likeable_type_and_likeable_id(likeable_type, likeable_id)
  end

  private
  	def create_remember_token
  		self.remember_token = SecureRandom.urlsafe_base64
  	end

    def find_vote(voteable)
      votes.find_by_voteable_type_and_voteable_id(voteable.class.base_class.name, voteable.id)
    end

    def vote_for!(voteable_type, voteable_id)
      votes.create!(vote:          true, 
                    voteable_type: voteable_type,
                    voteable_id:   voteable_id)
    end

    def vote_against!(voteable_type, voteable_id)
      votes.create!(vote:          false, 
                    voteable_type: voteable_type,
                    voteable_id:   voteable_id)
    end
end