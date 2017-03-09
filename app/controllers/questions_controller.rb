class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  after_action :create_question, only: [:create]

  include Voted

  def index
    @questions = Question.ordered.all
  end

  def show
    @question = Question.includes(:answers).find(params[:id])
    if user_signed_in?
      @answer = @question.answers.new
      @answer.attachments.build
      @comment = Comment.new
    end
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user

    if @question.save
      redirect_to question_path(@question), notice: 'Question successfully created'
    else
      render :new
    end
  end

  def update
    @question = find_question
    if current_user.author_of?(@question) && @question.update(question_params)
      flash.now[:notice] = 'Question was successfully edit'
    else
      flash.now[:alert] = 'Error'
    end
  end

  def destroy
    question = find_question
    if current_user.author_of?(question)
      question.destroy
      redirect_to questions_path, notice: 'Question successfully deleted'
    else
      flash[:alert] = 'Error'
      render :show
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_delete])
  end

  def find_question
    Question.find(params[:id])
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
