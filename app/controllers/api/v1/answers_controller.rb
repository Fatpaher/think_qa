class Api::V1::AnswersController < Api::V1::ApiController
  authorize_resource :answer

  def index
    @answers = Answer.all
    respond_with @answers
  end

  def show
    @answer = Answer.find(params[:id])
    respond_with @answer, serializer: ExtendAnswerSerializer
  end

  def create
    @question = Question.find(params[:question_id])
    respond_with @answer = @question.answers.create(answer_params.merge(user: current_resource_owner))
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
