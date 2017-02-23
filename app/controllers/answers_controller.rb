class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @answer = Question.find(params[:question_id]).answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      flash.now[:notice] = 'Answer succsesfully added'
    else
      flash.now[:alert] = 'Error'
    end
  end

  def update
    @answer = find_answer
    if current_user.author_of?(@answer) && @answer.update(answer_params)
      flash.now[:notice] = 'Answer was successfully edit'
    else
      flash.now[:alert] = 'Error'
    end
  end

  def destroy
    @answer = find_answer
    if current_user.author_of?(@answer)
      @answer.destroy
      flash.now[:notice] = 'Answer successfully deleted'
    else
      flash[:alert] = 'Error'
      render 'questions/show'
    end
  end

  def select_best
    @answer = find_answer
    @question = @answer.question
    if current_user.author_of?(@question)
      @answer.select_best
      flash.now[:notice] = 'Best Answer selected'
    else
      flash[:alert] = 'Error'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end

  def find_answer
    Answer.find(params[:id])
  end
end
