# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  #show form for new question comment
  $('.question .new-question-comment').on 'click', '.add-comment-link', (e) ->
    e.preventDefault();
    question_id = $('.question').data('questionId')
    $(this).hide();
    $('.question-comments').prepend(JST["templates/new_comment_form"]({commentable_type: 'questions', commentable_id: question_id}));

  #hide form for new question comment
  $('.question .question-comments').on 'click', '.cancel-comment-btn', (e) ->
    e.preventDefault();
    $(this).closest('.new-comment-form').remove();
    $('.new-question-comment .add-comment-link').show();

  #hide form for new answer comment
  $('.answers').on 'click', '.cancel-comment-btn', (e) ->
    e.preventDefault();
    $(this).closest('.answer').find('.add-comment-link').show();
    $(this).closest('.new-comment-form').remove();

  #show form for new answer comment
  $('.answers').on 'click', '.add-comment-link', (e) ->
    e.preventDefault();
    answer_id = $(this).closest('.show-answer-links').data('answerId')
    $(this).hide();
    $("#answer-#{ answer_id }-comments").prepend(JST["templates/new_comment_form"]({commentable_type: 'answers', commentable_id: answer_id}));

  #render new comments via comet
  question_id = $('.question').data('questionId')
  PrivatePub.subscribe "/questions/#{question_id}/comments", (data, channel) ->
    comment = $.parseJSON(data['comment'])
    commentable_type = data['commentable_type']
    commentable_id = data['commentable_id']
    comment_form = "<p>#{comment.body}</p>"
    $('.new-comment-form').remove();
    if commentable_type == 'Question'
      $('.question .question-comments').append(comment_form)
    else if commentable_type == 'Answer'
      $("#answer-#{commentable_id}-comments").append(comment_form)
