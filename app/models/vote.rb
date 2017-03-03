class Vote < ApplicationRecord
  VOTE_VALUE = [-1, 1].freeze

  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :value, inclusion: { in: VOTE_VALUE }

  after_create :rating_count
  after_destroy :rating_count

  private

  def rating_count
    votable.rating = votable.votes.sum(:value)
    votable.save
  end

end
