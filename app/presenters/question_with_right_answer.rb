class QuestionWithRightAnswer < SimpleDelegator
  def initialize(question)
    @question = question
    super
  end

  def answers
    return super unless @question.right_answer
    super.order("CASE answers.question_id WHEN #{@question.right_answer_id} THEN 1 ELSE 0 END ASC, created_at ASC")
  end
end
