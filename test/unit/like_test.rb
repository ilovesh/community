# == Schema Information
#
# Table name: likes
#
#  id            :integer          not null, primary key
#  like          :boolean          default(FALSE), not null
#  likeable_id   :integer          not null
#  likeable_type :string(255)      not null
#  user_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'test_helper'

class LikeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
