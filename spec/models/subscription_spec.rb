require 'rails_helper'

describe Subscription do
  context 'assosiations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:question) }
  end
end
