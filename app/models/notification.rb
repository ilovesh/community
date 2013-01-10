# == Schema Information
#
# Table name: notifications
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  notifiable_type :string(255)
#  notifiable_id   :integer
#  activity        :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  read            :boolean          default(FALSE)
#  referrer_id     :integer
#

class Notification < ActiveRecord::Base
  attr_accessible :notifiable_id, :notifiable_type, :activity, :read, :referrer_id
  belongs_to :notifiable, :polymorphic => true
  belongs_to :user

  validates :activity,   presence: true
  validates :notifiable_type, presence: true
  validates :notifiable_id,   presence: true
  validates :referrer_id, presence: true

  default_scope order: 'notifications.created_at DESC'
end
