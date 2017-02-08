require 'rails_helper'

describe AnswersController do
  describe 'POST #create' do
    let(:question) { create(:question) }

    context 'with valid attributes' do
      let(:answer_attr) { attributes_for(:answer) }

      it 'creates new answer to question' do
        params = { question_id: question.id,
                   answer: answer_attr }

        expect { post :create, params: params }.to change(question.answers, :count).by(1)
      end
      it 'redirect to answer page' do
        post :create, params: { question_id: question.id,
                                answer: answer_attr }
        expect(response).to redirect_to(question_path(question))
      end
    end

    context 'with invalid  attributes' do
      let(:invalid_answer_attr) { attributes_for(:answer, :invalid) }

      it "doesn't create new answer" do
        params = { question_id: question.id,
                   answer: invalid_answer_attr }

        expect { post :create, params: params }.not_to change(Question, :count)
      end

      it 're-renders answer page' do
        post :create, params: { question_id: question.id,
                                answer: invalid_answer_attr }
        expect(response).to render_template('questions/show')
      end
    end
  end
end
