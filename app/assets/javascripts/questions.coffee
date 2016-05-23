# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  #edit question on show page
  $('.question').on 'click', '.edit-question-link', (e) ->
    e.preventDefault();
    $(this).hide();
    $('.edit_question').show();

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
