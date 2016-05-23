# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  # render form for edit answer
  $('.answers').on 'click', '.edit-answer-link', (e) ->
    e.preventDefault();
    answer_id = $(this).data('answerId');
    $(this).hide();

    form = document.createElement("form");

    form.className = "edit_answer"
    form.setAttribute('accept-charset','UTF-8')
    form.setAttribute('method',"post")
    form.setAttribute('action', '/answers/' + answer_id)
    form.setAttribute('style', 'display: block;')
    form.setAttribute('data-remote', 'true')

    input1 = document.createElement("input")
    input1.setAttribute('type',"hidden")
    input1.setAttribute('name',"utf8")
    input1.setAttribute('value',"✓")

    input2 = document.createElement("input")
    input2.setAttribute('type',"hidden")
    input2.setAttribute('name',"_method")
    input2.setAttribute('value',"patch")

    div = document.createElement("div")
    div.className = 'form-group'

    label = document.createElement("label")
    label.setAttribute('for', 'answer_body')
    label.setAttribute('value', 'Answer')

    textarea = document.createElement("textarea")
    textarea.className = 'form-control'
    textarea.setAttribute('name', 'answer[body]')
    textarea.setAttribute('id', 'answer_body')

    submit = document.createElement("input")
    submit.setAttribute('type', 'submit')
    submit.setAttribute('name', 'commit')
    submit.setAttribute('value', 'Save')
    submit.setAttribute('class', 'btn btn-default')

    form.appendChild(input1)
    form.appendChild(input2)
    div.appendChild(label)
    div.appendChild(textarea)
    form.appendChild(div)
    form.appendChild(submit)

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
