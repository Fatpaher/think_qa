shared_examples 'POST voted#vote' do
  let(:vote) { attributes_for(:vote) }
  let(:invalid_vote) { attributes_for(:vote, :invalid) }
  context 'signed in user' do
    sign_in_user

    context 'not author of votable' do
      context 'with valid params' do
        let(:params) { { id: votable.id, value: vote[:value] } }

        it 'change count of votes for votable' do
          expect{ post :vote, params: params, format: :json }.to change(votable.votes, :count).by(1)
        end

        it 'change count of votes for user' do
          expect{ post :vote, params: params, format: :json }.to change(@user.votes, :count).by(1)
        end

        it 'assigns value to vote' do
          post :vote, params: params, format: :json
          expect(assigns(:vote).value).to eq(vote[:value])
        end

        it 'assigns votable' do
          post :vote, params: params, format: :json
          expect(assigns(:votable)).to eq(votable)
        end

        it 'returns created status' do
          post :vote, params: params, format: :json
          expect(response).to have_http_status(:success)
        end
      end

      context 'with invalid params' do
        let(:params) { { id: votable.id, value: invalid_vote[:value] } }

        it 'not change votes' do
          expect{ post :vote, params: params, format: :json }.not_to change(Vote, :count)
        end
      end
    end

    context 'author of votable' do
      let(:params) { { id: votable.id, value: vote[:value] } }
      before { votable.update(user_id: @user.id) }

      it 'not change votes' do
        expect{ post :vote, params: params, format: :json }.not_to change(Vote, :count)
      end


      it 'returns forbidden status' do
        post :vote, params: params, format: :json
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  context 'not signed in user' do
    let(:params) { { id: votable.id, value: vote[:value] } }

    it 'not change votes' do
      expect{ post :vote, params: params, format: :json }.not_to change(Vote, :count)
    end

    it 'retutns unauthorized status' do
      post :vote, params: params, format: :json
      expect(response).to have_http_status(:unauthorized)
    end
  end
end

