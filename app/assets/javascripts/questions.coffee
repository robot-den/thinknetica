# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('.question').on 'click', '.edit-question-link', (e) ->
    e.preventDefault();
    $(this).hide();
    $('.edit_question').show();

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
