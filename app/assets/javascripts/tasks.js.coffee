$ = jQuery;

$ ->
  $('.accordion-body').on 'shown', ->
    e = this.id+'-icon'
    $('#' + e).removeClass("icon-plus").addClass("icon-minus")
  $('.accordion-body').on 'hidden', ->
    e = this.id+'-icon'
    $('#' + e).removeClass("icon-minus").addClass("icon-plus")