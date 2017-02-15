class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy, :update]

  def index
    @questions = Question.all
  end

  def show
    @question = Question.includes(:answers).find(params[:id])
    @answer = @question.answers.new if user_signed_in?
    @question = QuestionWithRightAnswer.new(@question)
  end

  def new
    @question = Question.new
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
    @question = Question.find(params[:id])
    return unless current_user.author_of?(@question)

    if @question.update(question_params)
      flash.now[:notice] = 'Question was successfully edit'
    else
      flash.now[:alert] = 'Error'
    end
  end

  def destroy
    question = Question.find(params[:id])
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
    params.require(:question).permit(:title, :body)
  end
end
