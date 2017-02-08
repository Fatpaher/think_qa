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
    before { get :new }
    it 'it assigns new question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders :new template' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST :create' do
    context 'with valid attributes' do
      let(:question) { attributes_for(:question) }
      it 'saves new question to database' do
        expect { post :create, params: { question: question } }.to change(Question, :count).by(1)
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
end
