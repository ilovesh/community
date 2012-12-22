module Voteable
  def plusminus
    upvote_count - downvote_count
  end

  def upvote_count
    votes.where(vote: true).count
  end

  def downvote_count
    votes.where(vote: false).count
  end
end