class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      flash.now[:notice] = 'Answer succsesfully added'
    else
      flash.now[:alert] = 'Error'
    end
  end

  def update
    @question = Question.find(params[:question_id])
    @answer = Answer.find(params[:id])
    return unless current_user.author_of?(@answer)

    if @answer.update(answer_params)
      flash.now[:notice] = 'Answer was successfully edit'
    else
      flash.now[:alert] = 'Error'
    end
  end

  def destroy
    answer = Answer.find(params[:id])
    @question = Question.find(params[:question_id])
    if current_user.author_of?(answer)
      @question.remove_right_answer(answer)
      answer.destroy
      flash.now[:notice] = 'Answer successfully deleted'
    else
      flash[:alert] = 'Error'
      render 'questions/show'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
