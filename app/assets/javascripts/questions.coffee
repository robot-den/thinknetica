# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  #edit question on show page
  $('.question').on 'click', '.edit-question-link', (e) ->
    e.preventDefault();
    $(this).hide();
    $('.edit_question').show();

  #show form for new comment
  $('.question .comments').on 'click', '.add-comment-link', (e) ->
    e.preventDefault();
    question_id = $('.question').data('questionId')
    $(this).hide();
    $(this).closest('.comments').append(JST["templates/new_comment_form"]({commentable_type: 'questions', commentable_id: question_id}));

  #toggle vote links
  $('.question .rating a').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    $('.question .rating-value').html(response.rating)
    if response.voted == true
      $('.question .rating a.vote-cancel-link').show()
      $('.question .rating a.vote-up-link').hide()
      $('.question .rating a.vote-down-link').hide()
    else if response.voted == false
      $('.question .rating a.vote-cancel-link').hide()
      $('.question .rating a.vote-up-link').show()
      $('.question .rating a.vote-down-link').show()

  #render new question via comet
  PrivatePub.subscribe '/questions', (data, channel) ->
    question = $.parseJSON(data['question'])
    $('.questions').append(JST["templates/question"]({question: question}))

  #render new comments via comet
  question_id = $('.question').data('questionId')
  PrivatePub.subscribe "/questions/#{question_id}/comments", (data, channel) ->
    comment = $.parseJSON(data['comment'])
    commentable_type = data['commentable_type']
    commentable_id = data['commentable_id']
    comment_form = "<p>#{comment.body}</p>"
    if commentable_type == 'Question'
      $('.question .comments').append(comment_form)
    else if commentable_type == 'Answer'
      $("#answer-#{commentable_id} .comments").append(comment_form)
