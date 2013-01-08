# == Schema Information
#
# Table name: reviews
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  course_id  :integer
#  title      :string(255)
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Review < ActiveRecord::Base
  attr_accessible :body, :course_id, :title
  validates :body, presence: true
  validates :title, presence: true
  belongs_to :user
  belongs_to :course
  has_many :likes, dependent: :destroy, as: :likeable
  default_scope order: 'reviews.created_at DESC' 
end
