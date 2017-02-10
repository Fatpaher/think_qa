shared_examples "can't delete question" do
  it "doesn't destroy question" do
    params = { id: question }
    expect { delete :destroy, params: params }.not_to change(Question, :count)
  end
end

shared_examples "can't delete answer" do
  it "doesn't destroy answer" do
    params = { question_id: question.id, id: answer.id }
    expect { delete :destroy, params: params }.not_to change(Answer, :count)
  end
end
