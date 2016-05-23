# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  # render form for edit answer
  $('.answers').on 'click', '.edit-answer-link', (e) ->
    e.preventDefault();
    answer_id = $(this).data('answerId')
    form = "<form class=\"edit_answer\" accept-charset=\"UTF-8\" method=\"post\" action=\"/answers/#{answer_id}\" style=\"display: block;\" data-remote=\"true\">
        <input type=\"hidden\" name=\"utf8\" value=\"✓\">
        <input type=\"hidden\" name=\"_method\" value=\"patch\">
        <div class=\"form-group\">
          <label for=\"answer_body\" value=\"Answer\"></label>
          <textarea class=\"form-control\" name=\"answer[body]\" id=\"answer_body\"></textarea>
        </div>
        <input type=\"submit\" name=\"commit\" value=\"Save\" class=\"btn btn-default\">
      </form>"
    $(this).hide();
    $("#answer-#{answer_id} .panel-footer").append(form)

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
    $('.answers').append(answer.body)
