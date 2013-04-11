#= require ./vendor/jquery.chosen.min
#= require bootstrap-datepicker

$ = jQuery;

$ ->
  $('.chzn-select').chosen allow_single_deselect: true

  $('.add_fields').on 'click', ->
    setTimeout(->
      $('#project_tasks').find('.chzn-select').chosen()
    50)

  $('.deadline').datepicker({ "format": 'yyyy-mm-dd', "autoclose": true })