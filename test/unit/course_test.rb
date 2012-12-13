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

require 'test_helper'

class CourseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
