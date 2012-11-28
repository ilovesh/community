# == Schema Information
#
# Table name: enrollments
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  course_id  :integer
#  status     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# status:
# 1 - will take; 2 - taking; 3 - taken

class Enrollment < ActiveRecord::Base
  attr_accessible :course_id, :status, :user_id, :tag_list
  acts_as_taggable

  validates :course_id, presence: true, uniqueness: { scope: :user_id }
  validates :user_id,   presence: true
  validates :status,    presence: true, inclusion: {in: (1..3)}

  belongs_to :user
  belongs_to :course

end
