shared_examples 'Attachable' do
  it { is_expected.to have_many(:attachments).
    dependent(:destroy).
    inverse_of(:attachable)
  }
  it { is_expected.to accept_nested_attributes_for(:attachments) }
end

