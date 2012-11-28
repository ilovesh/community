# == Schema Information
#
# Table name: courses
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  provider_id :integer
#  progress    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  code        :string(255)
#  image_link  :string(255)
#  description :text
#

require 'test_helper'

class CourseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
