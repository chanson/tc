#= require ./vendor/jquery.chosen.min

$ = jQuery;

$ ->
  $('.chzn-select').chosen allow_single_deselect: true

  $('.add_fields').on 'click', ->
    setTimeout(->
      $('#project_tasks').find('.chzn-select').chosen()
    50)

