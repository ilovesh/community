# == Schema Information
#
# Table name: universities
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class University < ActiveRecord::Base
  attr_accessible :name
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  has_many :teachings, dependent: :destroy
  has_many :courses,    through: :teachings


  def teach!(course)
    teachings.create!(course_id: course.id)
  end
  
end
