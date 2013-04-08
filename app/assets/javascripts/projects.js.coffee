#= require ./vendor/jquery.chosen.min

$ = jQuery;

$ ->
  # $('.chzn-select').chosen allow_single_deselect: true

  # $('.add_fields').on 'click', ->
  #   setTimeout(->
  #     $('#project_tasks').find('.chzn-select').chosen()
  #   50)

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

  # $("form.new_task").on "ajax:success", (event, data, status, xhr) ->
  #   $('#new-task-modal').modal('hide')
  #   $('.chzn-results').append('<li class="result-selected" style>' + data.name + '</li>')
  #   $('.chzn-select').trigger('liszt:updated')
    # $('table tbody').append('<tr><td>' + data.title + '</td><td>' + data.content + '</td></tr>')

  # remove_fields = (link) ->
  #   $(link).prev("input[type=hidden]").val "1"
  #   $(link).closest(".fields").hide()

  # add_fields = (link, association, content) ->
  #   new_id = new Date().getTime()
  #   regex = new RegExp("new_" + association, "g")
  #   $(link).parent().after content.replace(regex, new_id)
  #   $("#new-task-fields").modal "show"

  rowBuilder = ->

    # Private property that define the default <TR> element text.
    row = $("<tr>",
      class: "fields"
    )

    # Public property that describes the "Remove" link.
    link = $("<a>",
      href: "#"
      onclick: "remove_fields(this); return false;"
      title: "Delete this Task."
    ).append($("<i>",
      class: "icon-remove"
    ))

    # A private method for building a <TR> w/the required data.
    buildRow = (fields) ->
      newRow = row.clone()
      $(fields).map(->
        $(this).removeAttr "class"
        $("<td/>").append $(this)
      ).appendTo newRow
      newRow


    # A public method for building a row and attaching it to the end of a <TBODY> element.
    attachRow = (tableBody, fields) ->
      row = buildRow(fields)
      $(row).appendTo $(tableBody)


    # Only expose public methods/properties.
    addRow: attachRow
    link: link

  cfg =
    formId: "#new-task-fields"
    tableId: "#tasks-table"
    inputFieldClassSelector: ".field"
    getTBodySelector: ->
      @tableId + " tbody"

  formHandler =
    appendFields: ->
      inputFields = $(cfg.formId + " " + cfg.inputFieldClassSelector)
      inputFields.detach()
      rowBuilder.addRow cfg.getTBodySelector(), inputFields
      rowBuilder.link.appendTo $("tr:last td:last")
    hideForm: ->
      $(cfg.formId).modal "hide"

  $('#addButton').on 'click', ->
    formHandler.appendFields()
    formHandler.hideForm()