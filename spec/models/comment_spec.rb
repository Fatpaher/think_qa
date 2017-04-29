require 'rails_helper'

describe Comment do
  context 'assosiations' do
    it { is_expected.to belong_to(:commentable).touch(true) }
    it { is_expected.to belong_to(:user) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:body) }
  end
end
