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
    comment_form = "<div class=\"comment-errors\"></div><form class=\"new_comment\" id=\"new_comment\" action=\"/questions/#{question_id}/create_comment\" accept-charset=\"UTF-8\" data-remote=\"true\" method=\"post\">
      <input name=\"utf8\" type=\"hidden\" value=\"✓\">
      <div class=\"form-group\">
        <label for=\"comment_body\">Comment</label>
        <textarea class=\"form-control\" name=\"comment[body]\" id=\"comment_body\"></textarea>
      </div>
      <input type=\"submit\" name=\"commit\" value=\"Send\" class=\"btn btn-default\">
    </form>"
    $(this).hide();
    $('.question .comments').append(comment_form);

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

    question_form = "<div class=\"panel panel-success\">
      <div class=\"panel-heading\">
        <h3 class=\"panel-title\">
          #{question.title}
        </h3>
      </div>
      <div class=\"panel-body\">
        <div class=\"col-lg-11\">
          #{question.body}
        </div>
        <div class=\"col-lg-1\">
          <a href=\"/questions/#{question.id}\">Read</a>
        </div>
      </div>
    </div>"

    $('.questions').append(question_form)

  #render new comments via comet
  question_id = $('.question').data('questionId')
  PrivatePub.subscribe "/questions/#{question_id}/comments", (data, channel) ->
    comment = $.parseJSON(data['comment'])
    commentable_type = data['commentable_type']
    commentable_id = data['commentable_id']
    comment_form = "<p>#{comment.body}</p>"
    console.log(data)
    if commentable_type == 'Question'
      $('.question .comments').append(comment_form)
