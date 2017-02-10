require 'rails_helper'

describe Question do
  context 'assosiations' do
    it { is_expected.to have_many(:answers).dependent(:destroy) }
    it { is_expected.to belong_to(:user) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:body) }
  end
end
