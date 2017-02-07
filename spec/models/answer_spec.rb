require 'rails_helper'

describe Answer do
  context 'assosiations' do
    it { is_expected.to belong_to(:question) }
  end
  context 'validations' do
    it { is_expected.to validate_presence_of(:body) }
  end
end
