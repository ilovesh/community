# == Schema Information
#
# Table name: notifications
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  notifiable_type :string(255)
#  notifiable_id   :integer
#  action_type     :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  read            :boolean          default(FALSE)
#  action_user_id  :integer
#  action_id       :integer
#

require 'test_helper'

class NotificationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
