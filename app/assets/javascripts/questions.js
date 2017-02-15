function editQuestion(button) {
  $(button).hide();
  $('.question-title').hide();
  $('.question-body').hide();
  $('.edit-question').show();
}

$(document).ready(function(){
  $('.edit-question-link').click(function(e) {
    e.preventDefault();
    editQuestion(this);
  });
});
