shared_examples "can't delete answer" do
  it "doesn't destroy answer" do
    params = { question_id: question.id, id: answer.id }
    expect { delete :destroy, params: params, format: :js }.not_to change(Answer, :count)
  end
end

shared_examples "can't update answer" do
  it 'not change answer attributes' do
    update_answer = attributes_for(:answer)
    params = { question_id: question.id, id: answer.id, answer: update_answer }

    patch :update, params: params, format: :js

    answer.reload
    expect(answer.body).not_to eq update_answer[:body]
  end
end
