# == Schema Information
#
# Table name: sessions
#
#  id         :integer          not null, primary key
#  course_id  :integer
#  start_date :datetime
#  final_date :datetime
#  duration   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  url        :string(255)
#

class Session < ActiveRecord::Base
  attr_accessible :duration, :final_date, :start_date, :url
  belongs_to :course
  validates :course_id, uniqueness: { scope: :start_date, case_sensitive: false }

  default_scope order: 'sessions.start_date DESC'
  scope :of_status, lambda{ |status| all.select{ |session| session.status == status.to_sym } }

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
      return :rolling  if final_date.nil? && time > start_date # in case of such a weird situation
      return :finished
    else
      return :rolling if duration == 0
      return :upcoming
    end
  end
end