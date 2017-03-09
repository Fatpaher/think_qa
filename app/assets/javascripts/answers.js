function editAnswer(button) {
  $(button).hide();
  var answer_id = $(button).data('answerId')
  $('#answer-body-' + answer_id).hide();
  $('#edit-answer-' + answer_id).parent().show();
}

$(document).ready(function(){
  $('.edit-answer-link').click(function(e) {
    e.preventDefault();
    editAnswer(this);
  });

  App.cable.subscriptions.create('AnswersChannel', {
    connected: function() {
      question_id = $(".question").data("question_id");
      this.perform('follow', { question_id: question_id });
    },
    received: function(data) {
      if (gon.user_id == data.answer.user_id) {
        return
      };
      $('.answers').append(JST['templates/answer']({
        answer: data.answer,
        question: data.question,
        attachments: data.attachments
      }));
    }
  });
});
