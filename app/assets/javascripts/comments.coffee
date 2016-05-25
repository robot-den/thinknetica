# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  #show form for new question comment
  $('.question .comments').on 'click', '.add-comment-link', (e) ->
    e.preventDefault();
    question_id = $('.question').data('questionId')
    $(this).hide();
    $(this).closest('.comments').append(JST["templates/new_comment_form"]({commentable_type: 'questions', commentable_id: question_id}));

  #show form for new answer comment
  $('.answers').on 'click', '.add-comment-link', (e) ->
    e.preventDefault();
    answer_id = $(this).closest('.answer').data('answerId')
    $(this).hide();
    $(this).closest('.comments').append(JST["templates/new_comment_form"]({commentable_type: 'answers', commentable_id: answer_id}));

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
