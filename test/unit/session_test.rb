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

require 'test_helper'

class SessionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
