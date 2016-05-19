# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('.answers').on 'click', '.edit-answer-link', (e) ->
    e.preventDefault();
    answer_id = $(this).data('answerId');
    $(this).hide();
    $('#edit-answer-' + answer_id).show();

  $('.answers .rating a').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    $('#answer-' + response.id + ' .rating-value').html(response.rating)
    if response.voted == true
      $('#answer-' + response.id + ' .rating a.vote-cancel-link').show()
      $('#answer-' + response.id + ' .rating a.vote-up-link').hide()
      $('#answer-' + response.id + ' .rating a.vote-down-link').hide()
    else if response.voted == false
      $('#answer-' + response.id + ' .rating a.vote-cancel-link').hide()
      $('#answer-' + response.id + ' .rating a.vote-up-link').show()
      $('#answer-' + response.id + ' .rating a.vote-down-link').show()
