class RightAnswersController < ApplicationController
  before_action :authenticate_user!

  def update
    @question = Question.find(params[:question_id])
    @answer = Answer.find(params[:id])
    if current_user.author_of?(@question)
      @question.right_answer = @answer
      @question.save!
      flash.now[:notice] = 'Right Answer selected'
    end
  end
end
