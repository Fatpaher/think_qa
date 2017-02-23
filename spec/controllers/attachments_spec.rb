require 'rails_helper'

describe AttachmentsController do
  describe 'DELETE #destroy' do
    context 'sign in user' do
      sign_in_user

      context 'author of question' do
        let(:question) { create(:question, user_id: @user.id) }
        let(:attachment) { create(:attachment, :for_question, attachable_id: question.id) }

        it 'assigns requested attachment' do
          params = { id: attachment.id }
          delete :destroy, params: params, format: :js

          expect(assigns(:attachment)).to eq attachment
        end

        it 'destroys question attachment attachment' do
          params = { id: attachment.id }
          expect { delete :destroy, params: params, format: :js }.to change(question.attachments, :count).by(-1)
        end
      end

      context 'is not author of question' do
        let(:question) { create(:question) }
        let(:attachment) { create(:attachment, :for_question, attachable_id: question.id) }

        it_behaves_like "can't delete attachment"
      end
    end

    context 'not sign in user' do
      let(:question) { create(:question) }
      let(:attachment) { create(:attachment, :for_question, attachable_id: question.id) }

      it_behaves_like "can't delete attachment"

      it 'it returns unauthoried status' do
        params = { id: attachment.id }
        delete :destroy, params: params, format: :js
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
