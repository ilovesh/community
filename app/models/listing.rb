# == Schema Information
#
# Table name: listings
#
#  id          :integer          not null, primary key
#  list_id     :integer
#  course_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :text
#

class Listing < ActiveRecord::Base
  attr_accessible :course_id, :list_id, :description
  validates :course_id, presence: true, uniqueness: { scope: :list_id }
  validates :list_id,   presence: true

  belongs_to :course
  belongs_to :list
  belongs_to :user

end
