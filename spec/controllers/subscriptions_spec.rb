require 'rails_helper'

describe SubscriptionsController do

  describe 'POST #create' do
    let(:question) { create(:question) }

    context 'signed in' do
      let(:params) { {question_id: question.id} }
      sign_in_user

      it 'creates new subscription to question' do
        expect { post :create, params: params, format: :js }.to change(question.subscriptions, :count).by(1)
      end

      it 'creates new subscription to user' do
        expect { post :create, params: params, format: :js }.to change(@user.subscriptions, :count).by(1)
      end

      it 'render create template' do
        post :create, params: params, format: :js
        expect(response).to render_template(:create)
      end
    end

    context 'not signed in' do
      let!(:params) { {question_id: question.id, user: nil} }
      it "doesn't create new subsciption" do
        expect { post :create, params: params, format: :js }.not_to change(Subscription, :count)
      end

      it 'return unauthorized status' do
        post :create, params: params, format: :js
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:question) { create(:question) }
    context 'sign in user' do
      sign_in_user

      let!(:subscription) { create(:subscription, user_id: @user.id, question_id: question.id) }
      let(:params) { {id: subscription.id} }

      it 'destroys subscription to question' do
        expect { delete :destroy, params: params, format: :js }.to change(question.subscriptions, :count).by(-1)
      end

      it 'destroys user subscription' do
        expect { delete :destroy, params: params, format: :js }.to change(@user.subscriptions, :count).by(-1)
      end
    end

    context 'not sign in user' do
      let!(:subscription) { create(:subscription, question_id: question.id) }
      let(:params) { {id: subscription.id} }

      it "doesn't destroy subscription" do
        expect { delete :destroy, params: params, format: :js }.not_to change(Subscription, :count)
      end

      it 'it returns unauthoried status' do
        delete :destroy, params: params, format: :js
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
