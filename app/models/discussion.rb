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
  
  validates :title,   presence: true
  validates :user_id, presence: true

  belongs_to :user

  default_scope order: 'discussions.created_at DESC'
end
