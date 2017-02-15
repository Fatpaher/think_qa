require 'rails_helper'

describe RightAnswersController do
  describe 'PATCH #update' do
    context 'sign in user' do
      sign_in_user

      context 'author of question' do
        let(:question) { create(:question, user_id: @user.id) }
        let(:answer) { create(:answer, question_id: question.id) }
        let(:params) { { question_id: question.id, id: answer.id } }
        before { patch :update, params: params, format: :js }

        it 'assigns requested question to @question' do
          expect(assigns(:question)).to eq(question)
        end

        it 'assigns requested answer to @answer' do
          expect(assigns(:answer)).to eq(answer)
        end

        it 'set requested answer as right answer to question' do
          question.reload
          expect(question.right_answer).to eq answer
        end

        it 'rensers #update template' do
          expect(response).to render_template :update
        end
      end

      context 'not author of question' do
        let(:question) { create(:question) }
        let(:answer) { create(:answer, question_id: question.id) }

        it_behaves_like 'not change question right answer'
      end
    end

    context 'not sign in user' do
      let(:question) { create(:question) }
      let(:answer) { create(:answer, question_id: question.id) }

      it_behaves_like 'not change question right answer'

      it 'it returns unauthoried status' do
        params = { question_id: question.id, id: answer.id }
        patch :update, params: params, format: :js

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
