# == Schema Information
#
# Table name: providers
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  website    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Provider < ActiveRecord::Base
  attr_accessible :name, :website
  
  validates :name,    presence: true, length: { maximum: 50 },
            uniqueness: { case_sensitive: false }
  validates :website, presence: true,
            uniqueness: { case_sensitive: false }
  
  has_many :courses, dependent: :destroy
  has_many :rolling_courses,  class_name: 'Course', conditions: ["status = ?", 0]
  has_many :upcoming_courses,   class_name: 'Course', conditions: ["status = ?", 1]
  has_many :ongoing_courses,  class_name: 'Course', conditions: ["status = ?", 2]
  has_many :finished_courses, class_name: 'Course', conditions: ["status = ?", 3]

end
