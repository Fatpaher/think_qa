shared_examples 'Votable' do
  it { is_expected.to have_many(:votes).dependent(:destroy) }
  it { is_expected.to accept_nested_attributes_for(:attachments) }
end
