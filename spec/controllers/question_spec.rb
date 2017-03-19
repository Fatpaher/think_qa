require 'rails_helper'

describe QuestionsController do
  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }
    before { get :index }

    it 'populates array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders :index template' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    let(:question) { create(:question) }

    context 'every user' do
      before { get :show, params: { id: question } }

      it 'assigns requested question ot @question' do
        expect(assigns(:question)).to eq(question)
      end

      it 'renders :show template' do
        expect(response).to render_template(:show)
      end
    end

    context 'user signed in' do
      sign_in_user
      before { get :show, params: { id: question } }
      it 'assigns new answer for question' do
        expect(assigns(:answer)).to be_a_new(Answer)
      end

      it 'builds new attachment for answer' do
        expect(assigns(:answer).attachments.first).to be_a_new(Attachment)
      end
    end

    context 'user not signed in' do
      before { get :show, params: { id: question } }
      it 'not assigns new answer' do
        expect(assigns(:answer)).not_to be_a_new(Answer)
      end
    end
  end

  describe 'GET #new' do
    context 'user signed in' do
      sign_in_user
      before { get :new }
      it 'it assigns new question to @question' do
        expect(assigns(:question)).to be_a_new(Question)
      end

      it 'renders :new template' do
        expect(response).to render_template(:new)
      end
    end

    context 'user not signed in' do
      before { get :new }
      it 'redirect to sign in url' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST #create' do
    context 'user signed in' do
      sign_in_user

      context 'with valid attributes' do
        let(:question) { attributes_for(:question) }
        it 'saves new question to database attached to user' do
          params = { question: question }
          expect { post :create, params: params }.to change(@user.questions, :count).by(1)
        end

        it 'redirect to created question show page' do
          post :create, params: { question: question }
          expect(response).to redirect_to(Question.last)
        end
      end
      context 'with invalid attributes' do
        let(:question) { attributes_for(:question, :invalid) }
        it "doesn't save question to database" do
          expect { post :create, params: { question: question } }.not_to change(Question, :count)
        end

        it 're-render :new template' do
          post :create, params: { question: question }
          expect(response).to render_template(:new)
        end
      end
    end

    context 'user not signed in' do
      let(:question) { attributes_for(:question) }
      it 'not saves new question to database' do
        expect { post :create, params: { question: question } }.not_to change(Question, :count)
      end

      it 'redirect to sign in url' do
        post :create, params: { question: question }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'PATCH #update' do
    context 'sign in user' do
      sign_in_user

      context 'author of question' do
        let(:question) { create(:question, user_id: @user.id) }
        let(:update_question) { attributes_for(:question) }
        let(:params) { { id: question, question: update_question } }
        before { patch :update, params: params, format: :js }

        it 'assigns requested question to @question' do
          expect(assigns(:question)).to eq(question)
        end

        it 'changes question attributes' do
          question.reload
          expect(question.title).to eq update_question[:title]
          expect(question.body).to eq update_question[:body]
        end

        it 'it render update template' do
          expect(response).to render_template :update
        end
      end

      context 'not author of question' do
        let(:question) { create(:question) }
        it_behaves_like "can't update question"

        it 'it render update template' do
          params = { id: question, question: attributes_for(:question) }

          patch :update, params: params, format: :js

          expect(response).to render_template :update
        end
      end
    end

    context 'not sign in user' do
      let(:question) { create(:question) }
      it_behaves_like "can't update question"

      it 'it returns unauthoried status' do
        params = { id: question, question: attributes_for(:question) }
        patch :update, params: params, format: :js

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'sign in user' do
      sign_in_user
      context 'user_id of question eq user' do
        let(:question) { create(:question, user_id: @user.id) }

        it 'destroys question' do
          params = { id: question }
          expect { delete :destroy, params: params }.to change(@user.questions, :count).by(-1)
        end

        it 'redirect to question list' do
          delete :destroy, params: { id: question }
          expect(response).to redirect_to(questions_path)
        end
      end

      context 'user_id of question not eq user' do
        let(:question) { create(:question) }

        it_behaves_like "can't delete question"
      end
    end

    context 'not sign in user' do
      let(:question) { create(:question) }

      it_behaves_like "can't delete question"

      it 'redirecto to sign in path' do
        delete :destroy, params: { id: question.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST #vote' do
    let(:votable) { create(:question) }
    it_behaves_like 'POST voted#vote'
  end

  describe 'DELETE #remove_vote' do
    let(:votable) { create(:question) }
    it_behaves_like 'DELETE voted#destroy_vote'
  end
end
