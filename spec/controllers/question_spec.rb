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
    before { get :show, params: { id: question } }
    it 'assigns requested question ot @question' do
      expect(assigns(:question)).to eq(question)
    end

    it 'renders :show template' do
      expect(response).to render_template(:show)
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

        it 're-reder question page' do
          delete :destroy, params: { id: question }
          expect(response).to render_template('questions/show')
        end
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
end
