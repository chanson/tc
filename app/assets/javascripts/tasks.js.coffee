#= require bootstrap-datepicker

$ = jQuery;

$ ->
  $('.accordion-body').on 'shown', ->
    e = this.id+'-icon'
    $('#' + e).removeClass("icon-plus").addClass("icon-minus")
  $('.accordion-body').on 'hidden', ->
    e = this.id+'-icon'
    $('#' + e).removeClass("icon-minus").addClass("icon-plus")

  $('.deadline').datepicker() format: 'yyyy-mm-dd'

  $(".datepicker").datepicker().on "changeDate", ->
    console.log('DATE CHANGED')
    $(this).blur()