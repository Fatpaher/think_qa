$(document).ready(function(){
  $(".add-comment").click(function(e) {
    e.preventDefault();
    $(this).hide();
    $(this).next(".add-comment-form").show();
  })

  App.cable.subscriptions.create('CommentsChannel', {
    connected: function() {
      this.perform('follow');
    },
    received: function(data) {
      var comment = data.comment;
      var commentId ='#' + comment.commentable_type.toLowerCase() + '-' + comment.commentable_id + '-comments';
      if (gon.user_id == data.comment.user_id) {
        return
      };
      $(commentId).append(JST['templates/comment']({
        comment: comment,
      }));
    }
  });
});
