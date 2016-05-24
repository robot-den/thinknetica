# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  # render form for edit answer
  $('.answers').on 'click', '.edit-answer-link', (e) ->
    e.preventDefault();
    answer_id = $(this).data('answerId')
    $(this).hide();
    console.log()
    $("#answer-#{answer_id} .answers-links").append(JST["templates/edit_answer_form"]({answer_id: answer_id}))

  #toggle links for votes
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

  #render new answers via comet
  question_id = $('.answers').data('questionId')
  PrivatePub.subscribe '/questions/' + question_id + '/answers', (data, channel) ->
    answer = $.parseJSON(data['answer'])
    $('.answers').append(JST["templates/answer"]({answer: answer}))

  #show form for new comment
  $('.answers .comments').on 'click', '.add-comment-link', (e) ->
    e.preventDefault();
    answer_id = $(this).closest('.answer').data('answerId')
    $(this).hide();
    $(this).closest('.comments').append(JST["templates/new_comment_form"]({commentable_type: 'answers', commentable_id: answer_id}));
