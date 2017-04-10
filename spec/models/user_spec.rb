require 'rails_helper'

describe User do
  context 'assosiations' do
    it { is_expected.to have_many(:questions) }
    it { is_expected.to have_many(:answers) }
    it { is_expected.to have_many(:votes) }
    it { is_expected.to have_many(:comments) }
    it { is_expected.to have_many(:subscriptions) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:email) }
  end

  describe '.find_for_oauth' do
    context 'user has already authoried' do
      let(:user) { create :user }
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345678')}
      it 'returns user' do
        user.authorizations.create(provider: 'facebook', uid: '12345678')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has no authorization' do
      context 'provider return email'do
        context 'user already exists' do
          let!(:user) { create :user }
          let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345678', info: { email: user.email })}
          it 'does not create new user' do
            expect { User.find_for_oauth(auth)}.not_to change(User, :count)
          end

          it 'creates authorization for user' do
            expect { User.find_for_oauth(auth)}.to change(user.authorizations, :count).by(1)
          end

          it 'creates authorization with provider and uid' do
            authorization = User.find_for_oauth(auth).authorizations.first

            expect(authorization.provider).to eq auth.provider
            expect(authorization.uid).to eq auth.uid
          end

          it 'returns user' do
            expect(User.find_for_oauth(auth)).to eq user
          end

          it 'returns confirmed user' do
            expect(User.find_for_oauth(auth)).to be_confirmed
          end
        end

        context "user doesn't exists" do
          let(:user_attr) { attributes_for :user }
          let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345678', info: { email: user_attr[:email] })}

          it 'creates new user' do
            expect{ User.find_for_oauth(auth) }.to change(User, :count).by(1)
          end

          it 'returns new user' do
            expect(User.find_for_oauth(auth)).to be_a(User)
          end

          it 'fills user email' do
            user = User.find_for_oauth(auth)
            expect(user.email).to eq auth.info[:email]
          end

          it 'creates authorization for user' do
            user = User.find_for_oauth(auth)
            expect(user.authorizations).not_to be_empty
          end

          it 'creates authorization with provider and uid' do
            authorization = User.find_for_oauth(auth).authorizations.first

            expect(authorization.uid).to eq auth.uid
            expect(authorization.provider).to eq auth.provider
          end

          it 'returns confirmed user' do
            expect(User.find_for_oauth(auth)).to be_confirmed
          end
        end
      end
    end

    context "provider don't return email and user add it manually" do
      let(:user_attr) { attributes_for :user }
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345678', unconfirm: 'true', info: { email: user_attr[:email]} ) }
      it 'create new user' do
        expect{ User.find_for_oauth(auth) }.to change(User, :count).by(1)
      end

      it 'returns new user' do
        expect(User.find_for_oauth(auth)).to be_a(User)
      end

      it 'fiills in email from params' do
        expect(User.find_for_oauth(auth).email).to eq user_attr[:email]
      end

      it 'creates authorization for user' do
        user = User.find_for_oauth(auth)
        expect(user.authorizations).not_to be_empty
      end

      it 'creates authorization with provider and uid' do
        authorization = User.find_for_oauth(auth).authorizations.first

        expect(authorization.uid).to eq auth.uid
        expect(authorization.provider).to eq auth.provider
      end

      it 'returns unconfirmed user' do
        expect(User.find_for_oauth(auth)).not_to be_confirmed
      end
    end
  end
end
