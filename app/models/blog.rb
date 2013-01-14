class Blog < ActiveRecord::Base
  attr_accessible :body, :title
  validates :body,   presence: true
  default_scope order: 'blogs.created_at DESC'
end
