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

  describe 'PATCH #update' do
    let(:question) { create(:question) }
    context 'sign in user' do
      sign_in_user

      context 'author of an answer' do
        let(:answer) { create(:answer, question_id: question.id, user_id: @user.id) }
        let(:update_answer) { attributes_for(:answer) }
        let(:params) { { question_id: question.id, id: answer.id, answer: update_answer } }
        before { patch :update, params: params, format: :js }

        it 'assigns requested answer to @answer' do
          expect(assigns(:answer)).to eq(answer)
        end

        it 'changes answer attribute' do
          answer.reload
          expect(answer.body).to eq update_answer[:body]
        end

        it 'render update template' do
          expect(response).to render_template :update
        end
      end

      context 'not author of answer' do
        let(:answer) { create(:answer) }

        it_behaves_like "can't update answer"

        it 'render update template' do
          params = { question_id: question.id, id: answer.id, answer: attributes_for(:answer) }

          patch :update, params: params, format: :js

          expect(response).to render_template :update
        end
      end
    end

    context 'not sign in user' do
      let(:answer) { create(:answer, question_id: question.id) }

      it_behaves_like "can't update answer"
      it 'it returns unauthoried status' do
        params = { question_id: question.id, id: answer.id, answer: attributes_for(:answer) }
        patch :update, params: params, format: :js

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
          expect { delete :destroy, params: params, format: :js }.to change(question.answers, :count).by(-1)
        end
      end

      context 'is not author of answer' do
        let(:answer) { create(:answer, question_id: question.id) }

        it_behaves_like "can't delete answer"

        it 're-reder answer page' do
          params = { question_id: question.id, id: answer.id }
          delete :destroy, params: params, format: :js
          expect(response).to render_template('questions/show')
        end
      end
    end

    context 'not sign in user' do
      let(:answer) { create(:answer, question_id: question.id) }

      it_behaves_like "can't delete answer"

      it 'it returns unauthoried status' do
        params = { question_id: question.id, id: answer.id }
        delete :destroy, params: params, format: :js
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PATCH #select_best' do
    context 'sign in user' do
      sign_in_user

      context 'author of question' do
        let(:question) { create(:question, user_id: @user.id) }
        let(:answer) { create(:answer, question_id: question.id) }
        let(:previos_best_answer) { create(:answer, :best_answer, question_id: question.id) }
        let(:params) { { question_id: question.id, id: answer.id } }
        before { patch :select_best, params: params, format: :js }

        it 'assigns requested answer to @answer' do
          expect(assigns(:answer)).to eq(answer)
        end

        it 'assigns requested answer question to @question' do
          expect(assigns(:question)).to eq(question)
        end

        it 'set requested answer as best answer to question' do
          answer.reload
          expect(answer.best_answer).to be_truthy
        end

        it 'rensers #select_best template' do
          expect(response).to render_template :select_best
        end
      end

      context 'not author of question' do
        let(:question) { create(:question) }
        let(:answer) { create(:answer, question_id: question.id) }

        it_behaves_like 'not change question best answer'
      end
    end

    context 'not sign in user' do
      let(:question) { create(:question) }
      let(:answer) { create(:answer, question_id: question.id) }

      it_behaves_like 'not change question best answer'

      it 'it returns unauthoried status' do
        params = { question_id: question.id, id: answer.id }
        patch :select_best, params: params, format: :js

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST #vote' do
    let(:votable) { create(:answer) }
    it_behaves_like 'POST voted#vote'
  end
  describe 'DELETE #remove_vote' do
    let(:votable) { create(:answer) }
    it_behaves_like 'DELETE voted#destroy_vote'
  end
end
