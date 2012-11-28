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

require 'test_helper'

class ListingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
