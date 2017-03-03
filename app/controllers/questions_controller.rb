class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]

  include Voted

  def index
    @questions = Question.all
  end

  def show
    @question = Question.includes(:answers).find(params[:id])
    if user_signed_in?
      @answer = @question.answers.new
      @answer.attachments.build
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
end
