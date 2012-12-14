# == Schema Information
#
# Table name: teachings
#
#  id            :integer          not null, primary key
#  university_id :integer
#  course_id     :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Teaching < ActiveRecord::Base
  attr_accessible :course_id, :university_id

  validates :course_id,       presence: true, uniqueness: { scope: :university_id }
  validates :university_id,   presence: true

  belongs_to :university
  belongs_to :course

end
