#= require ./vendor/jquery.chosen.min

$ = jQuery;

$ ->
  $('.chzn-select').chosen allow_single_deselect: true

  $('.add_fields').on 'click', ->
    setTimeout(->
      $('#project_tasks').find('.chzn-select').chosen()
    50)

  # $target = $('#js-new-task')

  # $target
  #   .on 'change', 'form', ->
  #     $target.find('input[type=submit]').removeProp('disabled')

  #   .on 'click', 'input[type=submit]', ->
  #     $target.find('form').submit()


  # $(document).on 'click', '[data-toggle="modal"]', ( e ) ->
  #     e.preventDefault()
  #     url = $(@).attr('href')
  #     modal = $ $(@).data('target')

  #     if url.indexOf('#') == 0
  #       $( url ).modal('open')
  #     else
  #       $.ajax
  #         url: url
  #         type: 'GET'
  #         success: ( data ) ->
  #           modal.find('.modal-body').html( data ).end().modal()

  $("form.new_task").on "ajax:success", (event, data, status, xhr) ->
    $('#new-task-modal').modal('hide')
    $('.chzn-results').append('<li class="result-selected" style>' + data.name + '</li>')
    $('.chzn-select').trigger('liszt:updated')
    # $('table tbody').append('<tr><td>' + data.title + '</td><td>' + data.content + '</td></tr>')