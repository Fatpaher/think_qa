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
});
