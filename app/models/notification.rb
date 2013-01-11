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

class Notification < ActiveRecord::Base
  attr_accessible :notifiable_id, :notifiable_type, :action_type, :action_id, :action_user_id, :read
  belongs_to :notifiable, :polymorphic => true
  belongs_to :user

  validates :notifiable_type, presence: true
  validates :notifiable_id,   presence: true
  validates :action_type, presence: true
  validates :action_id,   presence: true  
  validates :action_user_id, presence: true

  default_scope order: 'notifications.created_at DESC'
end
