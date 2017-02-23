require 'rails_helper'

describe Attachment do
  context 'assosiations' do
    it { is_expected.to belong_to(:attachable) }
  end
end
