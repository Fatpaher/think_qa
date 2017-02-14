require 'rails_helper'

describe AnswersController do
  describe 'POST #create' do
    let(:question) { create(:question) }

    context 'signed in' do
      sign_in_user

      context 'with valid attributes' do
        let(:answer_attr) { attributes_for(:answer) }

        it 'creates new answer to question' do
          params = { question_id: question.id,
                    answer: answer_attr }

          expect { post :create, params: params, format: :js }.to change(question.answers, :count).by(1)
        end

        it 'creates new answer assigned to user' do
          params = { question_id: question.id,
                    answer: answer_attr }

          expect { post :create, params: params, format: :js }.to change(@user.answers, :count).by(1)
        end

        it 'render create template' do
          params = { question_id: question.id,
                     answer: answer_attr }
          post :create, params: params, format: :js
          expect(response).to render_template(:create)
        end
      end

      context 'with invalid  attributes' do
        let(:invalid_answer_attr) { attributes_for(:answer, :invalid) }

        it "doesn't create new answer" do
          params = { question_id: question.id,
                    answer: invalid_answer_attr }

          expect { post :create, params: params, format: :js }.not_to change(Answer, :count)
        end

        it 're-renders answer page' do
          params = { question_id: question.id,
                     answer: invalid_answer_attr }
          post :create, params: params, format: :js
          expect(response).to render_template(:create)
        end
      end
    end

    context 'not signed in' do
      let(:answer_attr) { attributes_for(:answer) }

      it "doesn't create new answer" do
        params = { question_id: question.id,
                   answer: answer_attr }

        expect { post :create, params: params, format: :js }.not_to change(Answer, :count)
      end

      it 'redrect to root page' do
        params = { question_id: question.id,
                   answer: answer_attr }
        post :create, params: params, format: :js
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:question) { create(:question) }
    context 'sign in user' do
      sign_in_user

      context 'author of answer' do
        let(:answer) { create(:answer, user_id: @user.id, question_id: question.id) }

        it 'destroys answer to question' do
          params = { question_id: question.id, id: answer.id }
          expect { delete :destroy, params: params }.to change(question.answers, :count).by(-1)
        end

        it 'redirect to question' do
          params = { question_id: question.id, id: answer.id }
          delete :destroy, params: params
          expect(response).to redirect_to(question_path(question))
        end
      end

      context 'is not author of answer' do
        let(:answer) { create(:answer, question_id: question.id) }

        it_behaves_like "can't delete answer"

        it 're-reder answer page' do
          params = { question_id: question.id, id: answer.id }
          delete :destroy, params: params
          expect(response).to render_template('questions/show')
        end
      end
    end

    context 'not sign in user' do
      let(:answer) { create(:answer, question_id: question.id) }

      it_behaves_like "can't delete answer"

      it 'redirecto to sign in path' do
        params = { question_id: question.id, id: answer.id }
        delete :destroy, params: params
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
