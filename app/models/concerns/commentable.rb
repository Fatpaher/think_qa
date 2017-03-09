module Commentable
  extend ActiveSupport::Concern

  included do
    has_many :comments, -> { ordered }, as: :commentable, dependent: :destroy
  end
end

