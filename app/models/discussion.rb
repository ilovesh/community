# == Schema Information
#
# Table name: discussions
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  content    :text
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Discussion < ActiveRecord::Base
  attr_accessible :content, :title, :tag_list
  acts_as_commentable
  acts_as_taggable
  belongs_to :user
  has_many :likes, dependent: :destroy, as: :likeable
  has_many :notifications, dependent: :destroy, as: :notifiable

  validates :title,   presence: true, length: { maximum: 140 }

  default_scope order: 'discussions.created_at DESC'
  scope :of_status, lambda{ |status| all.select{ |course| course.status == status.to_sym } }
end
