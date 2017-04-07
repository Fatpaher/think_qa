shared_examples "can't delete question" do
  it "doesn't destroy question" do
    params = { id: question }
    expect { delete :destroy, params: params }.not_to change(Question, :count)
  end
end

shared_examples "can't update question" do
  it 'not change question' do
    update_question = attributes_for(:question)
    params = { id: question.id, question: update_question }

    patch :update, params: params, format: :js

    question.reload
    expect(question.title).not_to eq update_question[:title]
    expect(question.body).not_to eq update_question[:body]
  end
end

shared_examples 'not change question best answer' do
  it 'not set answer as best answer to question' do
    answer.reload
    expect(answer.best_answer).to be_falsy
  end
end

