shared_examples "can't delete attachment" do
  it "doesn't destroy attachment" do
    params = { id: attachment.id }
    expect { delete :destroy, params: params, format: :js }.not_to change(Attachment, :count)
  end
end
