shared_examples 'DELETE voted#destroy_vote' do
  context 'signed in user' do
    sign_in_user

    context 'author of vote' do
      let!(:vote) { create(:vote, votable: votable, user_id: @user.id) }
      let(:params) { { id: votable.id } }

      it 'change count of votes for votable' do
        expect{ delete :destroy_vote, params: params, format: :json }.to change(votable.votes, :count).by(-1)
      end

      it 'change count of votes for user' do
        expect{ delete :destroy_vote, params: params, format: :json }.to change(@user.votes, :count).by(-1)
      end

      it 'assigns votable' do
        delete :destroy_vote, params: params, format: :json
        expect(assigns(:votable)).to eq(votable)
      end

      it 'returns success status' do
        delete :destroy_vote, params: params, format: :json
        expect(response).to have_http_status(:success)
      end
    end

    context 'not author of vote' do
      let!(:vote) { create(:vote, votable: votable) }
      let(:params) { { id: votable.id } }
      before { votable.update(user_id: @user.id) }

      it 'not change votes' do
        expect{ delete :destroy_vote, params: params, format: :json }.not_to change(Vote, :count)
      end

      it 'returns forbidden status' do
        delete :destroy_vote, params: params, format: :json
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  context 'not signed in user' do
    let!(:vote) { create(:vote, votable: votable) }
    let(:params) { { id: votable.id } }

    it 'not change votes' do
      expect{ delete :destroy_vote, params: params, format: :json }.not_to change(Vote, :count)
    end


    it 'retutns unauthorized status' do
      delete :destroy_vote, params: params, format: :json
      expect(response).to have_http_status(:unauthorized)
    end
  end
end

shared_examples 'voted ability' do
  context 'vote' do
    it { is_expected.to be_able_to :vote, other_user_votable, user: user }
    it { is_expected.not_to be_able_to :vote, user_votable, user: user }
  end

  context 'destroy_vote' do
    it { is_expected.to be_able_to :destroy_vote, other_user_votable, user: user }
    it { is_expected.not_to be_able_to :destroy_vote, user_votable, user: user }
  end
end
