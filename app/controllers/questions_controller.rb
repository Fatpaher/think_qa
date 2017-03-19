class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :find_question_with_answers, only: [:show]
  before_action :build_answer, only: [:show]
  before_action :load_question, only: [:update, :destroy]

  after_action :create_question, only: [:create]

  respond_to :js, only: [:update]

  include Voted

  def index
    respond_with @questions = Question.ordered.all
  end

  def show
    respond_with @question
  end

  def new
    respond_with @question = Question.new
  end

  def create
    respond_with @question = current_user.questions.create(question_params)
  end

  def update
    return unless current_user.author_of?(@question)
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    return unless current_user.author_of?(@question)
    respond_with @question.destroy
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_delete])
  end

  def load_question
    @question = Question.find(params[:id])
  end

  def find_question_with_answers
    @question = Question.includes(:answers).find(params[:id])
  end

  def build_answer
    if user_signed_in?
      @answer = @question.answers.new
      @answer.attachments.build
    end
  end

  def create_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/question_preview',
        locals: { question: @question }
      )
    )
  end
end
