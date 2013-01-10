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

class Like < ActiveRecord::Base
  attr_accessible :like, :likeable_type, :likeable_id
  belongs_to :likeable, :polymorphic => true
  belongs_to :user

  validates :like,   presence: true
  validates :likeable_type, presence: true
  validates :likeable_id,   presence: true
  validates_uniqueness_of :likeable_id, :scope => [:likeable_type, :user_id]

  default_scope order: 'likes.created_at DESC'
  scope :for_likeable, lambda { |*args| 
  	where(["likeable_type = ? AND likeable_id = ?", args.first.class.base_class.name, args.first.id]) 
  }

  def find_likeable
    likeable_type.constantize.find(likeable_id)
  end

end
