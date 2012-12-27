# == Schema Information
#
# Table name: votes
#
#  id            :integer          not null, primary key
#  vote          :boolean          default(FALSE), not null
#  voteable_id   :integer          not null
#  voteable_type :string(255)      not null
#  user_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Vote < ActiveRecord::Base

  attr_accessible :vote, :voteable_type, :voteable_id
  belongs_to :voteable, :polymorphic => true

  validates :vote,   presence: true
  validates :voteable_type, presence: true
  validates :voteable_id,   presence: true    
  # Comment out the line below to allow multiple votes per user.
  validates_uniqueness_of :voteable_id, :scope => [:voteable_type, :user_id]

  default_scope order: 'votes.created_at DESC'
  scope :for_voteable, lambda { |*args| 
  	where(["voteable_type = ? AND voteable_id = ?", args.first.class.base_class.name, args.first.id]) 
  }
  scope :recent, lambda { |*args|
   where(["created_at > ?", (args.first || 2.weeks.ago)])
  }



end
