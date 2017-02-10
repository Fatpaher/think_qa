class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      redirect_to question_path(@question), notice: 'Answer succsesfully added'
    else
      render 'questions/show'
    end
  end

  def destroy
    answer = Answer.find(params[:id])
    if current_user.author_of?(answer)
      answer.destroy
      redirect_to question_path(params[:question_id]), notice: 'Answer successfully deleted'
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
