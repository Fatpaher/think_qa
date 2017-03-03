$(document).ready(function(){
  $('.vote-up-button, .vote-down-button').bind('ajax:success', function(e, data, status, xhr) {
    var json = $.parseJSON(xhr.responseText);
    var vote = json.vote;
    var votable = json.votable;
    var voteClass = vote.votable_type.toLowerCase();
    var ratingId = '#rating-' + voteClass + '-' + votable.id;
    var voteButtonsId = '#vote-buttons-' + voteClass + '-' + votable.id;
    $(ratingId).html('Rating ' + votable.rating);
    $(voteButtonsId + ' .vote-up-button').hide();
    $(voteButtonsId + ' .vote-down-button').hide();
    $(voteButtonsId + ' .reset-vote-button').show();
  });

  $('.reset-vote-button').bind('ajax:success', function(e, data, status, xhr) {
    var json = $.parseJSON(xhr.responseText);
    var vote = json.vote;
    var votable = json.votable;
    var voteClass = vote.votable_type.toLowerCase();
    var ratingId = '#rating-' + voteClass + '-' + votable.id;
    var voteButtonsId = '#vote-buttons-' + voteClass + '-' + votable.id;
    $(ratingId).html('Rating ' + votable.rating);
    $(voteButtonsId + ' .vote-up-button').show();
    $(voteButtonsId + ' .vote-down-button').show();
    $(voteButtonsId + ' .reset-vote-button').hide();
  });
});
