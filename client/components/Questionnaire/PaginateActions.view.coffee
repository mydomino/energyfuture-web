{div, input} = React.DOM

module.exports = React.createClass
  displayName: 'PaginateActions'

  getDefaultProps: ->
    page: 1
    totalPageCount: 1

  disableNext: ->
    @props.page == @props.totalPageCount

  disablePrev: ->
    @props.page == 1

  componentDidMount: ->
    #this is done to trigger html validations
    $(".questionnaire-form").on 'submit', (event) ->
      event.preventDefault()

  prevAction: ->
    @props.prevAction() unless @disablePrev()

  isFormValid: ->
    $('.questionnaire-form')[0].checkValidity()

  nextAction: ->
    if @isFormValid() && !@disableNext()
      @props.nextAction()

  render: ->
    previousClass = if @disablePrev() then 'disabled' else ''
    nextClass = if @disableNext() then 'disabled' else ''

    div {className: 'questionnaire-paginate-actions'},
      input {type: 'button', className: "previous #{previousClass}", onClick: @prevAction, defaultValue: "Previous"}
      input {type: 'submit', className: "next #{nextClass}", onClick: @nextAction, defaultValue: "Next"}
      div {className: 'clear-both'}
