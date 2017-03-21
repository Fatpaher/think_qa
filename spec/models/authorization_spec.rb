require 'rails_helper'

describe Authorization do
  context 'assosiations' do
    it { is_expected.to belong_to(:user) }
  end

  context 'validations' do
    subject { FactoryGirl.build(:authorization) }
    it { is_expected.to validate_presence_of(:uid) }
    it { is_expected.to validate_presence_of(:provider) }
    it { is_expected.to validate_uniqueness_of(:uid).scoped_to(:provider) }
  end

  describe '.find_for_oauth' do
    context 'authorization exists' do
      let(:authorization) { create :authorization}
      let(:auth) { OmniAuth::AuthHash.new(provider: authorization.provider, uid: authorization.uid) }

      it 'returns authorization' do
        expect(Authorization.find_for_oauth(auth)).to eq authorization
      end
    end

    context 'authorization not exist' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345678')}

      it 'returns nil' do
        expect(Authorization.find_for_oauth(auth)).to eq nil
      end
    end
  end
end
