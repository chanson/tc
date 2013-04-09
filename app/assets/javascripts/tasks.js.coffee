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

  # $('#complete-task').on 'click', ->
  #     # broadcastDate = $('.broadcast-content').data('page_refreshed_at')
  #     console.log('clicked')
  #     console.log($('#complete-task').data('task'))
  #     $.ajax
  #       url: "/tasks/"+$('#complete-task').data('task')
  #       data:
  #         task: #$('#complete-task').data('task')
  #           completed: true
  #       type: 'PUT'
  #       success: ->
  #         console.log($(this).parent())
  #         $('#tr').fadeOut('fast')