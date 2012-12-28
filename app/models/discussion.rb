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
  attr_accessible :content, :title
  acts_as_commentable
  acts_as_taggable
  has_many :votes, dependent: :destroy, as: :voteable
  include Voteable

  validates :title,   presence: true
  validates :user_id, presence: true

  belongs_to :user

  default_scope order: 'discussions.created_at DESC'

  scope :of_status, lambda{ |status| all.select{ |course| course.status == status.to_sym } }
end
