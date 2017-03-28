class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, only: [:update, :destroy, :select_best]
  before_action :load_answer_question, only: [ :update, :destroy, :select_best ]

  after_action :create_answer, only: [:create]

  respond_to :js

  include Voted

  authorize_resource

  def create
    @question = Question.find(params[:question_id])
    respond_with @answer = @question.answers.create(answer_params.merge(user: current_user))
  end

  def update
    @answer.update(answer_params)
    respond_with  @answer
  end

  def destroy
    respond_with @answer.destroy
  end

  def select_best
    respond_with @answer.select_best
  end

  private

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_answer_question
    @question = @answer.question
  end

  def create_answer
    return if @answer.errors.any?
    attachments = @answer.attachments.map(&:attributes)

    ActionCable.server.broadcast(
      "answers_for_question-#{@question.id}",
      answer: @answer,
      question: @question,
      attachments: attachments
    )
  end
end
