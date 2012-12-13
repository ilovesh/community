class Teaching < ActiveRecord::Base
  attr_accessible :course_id, :university_id

  validates :course_id,       presence: true, uniqueness: { scope: :university_id }
  validates :university_id,   presence: true

  belongs_to :university
  belongs_to :course

end