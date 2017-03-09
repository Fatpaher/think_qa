require 'rails_helper'

describe CommentsController do
  let(:commentable) { create(:question) }
  let(:comment_attr) { attributes_for(:comment) }
  let(:comment) { { body: comment_attr[:body], commentable_type: commentable.class.name, commentable_id: commentable.id } }
  let(:invalid_comment) { { body: '', commentable_type: commentable.class.name, commentable_id: commentable.id } }
  context 'signed in user' do
    sign_in_user

    context 'with valid params' do
      let(:params) { { comment: comment } }

      it 'create new comment to question' do
        expect{ post :create, params: params, format: :js}.to change(commentable.comments, :count).by(1)
      end

      it 'changes count of comments of user' do
        expect{ post :create, params: params, format: :js}.to change(@user.comments, :count).by(1)
      end

      it 'assigns commentable' do
        post :create, params: params, format: :js
        expect(assigns(:commentable)).to eq(commentable)
      end

      it 'assigns comment body to @comment' do
        post :create, params: params, format: :js
        expect(assigns(:comment).body).to eq(comment[:body])
      end

      it 'returns created status' do
        post :create, params: params, format: :js
        expect(response).to have_http_status(:success)
      end
    end

    context 'with invalid params' do
      let(:params) { { comment: invalid_comment } }
      it 'not change comments count' do
        expect{ post :create, params: params, format: :js }.not_to change(Comment, :count)
      end
    end
  end

  context 'not signed in user' do
    let(:params) { { comment: comment } }
    it 'not create comment' do
    expect{ post :create, params: params, format: :js }.not_to change(Comment, :count)
    end

    it 'returns unauthorized staus' do
      post :create, params: params, format: :js
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
