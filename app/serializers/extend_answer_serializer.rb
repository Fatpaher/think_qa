class ExtendAnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :rating, :best_answer, :question_id, :user_id, :created_at, :updated_at
  has_many :comments
  has_many :attachments
end
