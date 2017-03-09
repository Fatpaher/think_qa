require 'rails_helper'

describe User do
  context 'assosiations' do
    it { is_expected.to have_many(:questions) }
    it { is_expected.to have_many(:answers) }
    it { is_expected.to have_many(:votes) }
    it { is_expected.to have_many(:comments) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:email) }
  end
end
