# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  commentable_id   :integer          default(0)
#  commentable_type :string(255)      default("")
#  body             :text             default("")
#  user_id          :integer          default(0), not null
#  parent_id        :integer
#  lft              :integer
#  rgt              :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Comment < ActiveRecord::Base
  attr_accessible :commentable_type, :commentable_id, :body, :title
  acts_as_nested_set :scope => [:commentable_id, :commentable_type]
  has_many :likes, dependent: :destroy, as: :likeable

  validates_presence_of :body
  validates_presence_of :user

  belongs_to :commentable, :polymorphic => true
  belongs_to :user

  default_scope order: 'comments.created_at DESC'
  scope :find_comments_by_user, lambda { |user|
    where(:user_id => user.id).order('created_at DESC')
  }

  scope :find_comments_for_commentable, lambda { |commentable_str, commentable_id|
    where(:commentable_type => commentable_str.to_s, 
          :commentable_id => commentable_id).order('created_at DESC')
  }

  def self.build_from(obj, user_id, comment, *arg)
    c = self.new
    c.commentable_id = obj.id
    c.commentable_type = obj.class.base_class.name
    c.body = comment
    c.user_id = user_id
    c
  end

  def has_children?
    self.children.size > 0
  end

  def self.find_commentable(commentable_str, commentable_id)
    commentable_str.constantize.find(commentable_id)
  end

  def self.find_commentables_commented_by_user(commentable_str, user)
    where(commentable_type: commentable_str.to_s, user_id: user.id).order('created_at DESC')
  end



end
