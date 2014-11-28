{div} = React.DOM

module.exports = React.createClass
  displayName: 'PaginateActions'

  getDefaultProps: ->
    page: 1
    totalPageCount: 1
    nextClass: ''
    previousClass: ''

  disableNext: ->
    @props.page == @props.totalPageCount

  disablePrev: ->
    @props.page == 1

  render: ->
    previousClass = @props.previousClass + 'disabled' if @disablePrev()
    nextClass = @props.nextClass + 'disabled' if @disableNext()

    div {className: 'questionnaire-paginate-actions'},
      div {className: "previous #{previousClass}", onClick: => @props.prevAction() unless @disablePrev()}, "Previous"
      div {className: "next #{nextClass}", onClick: => @props.nextAction() unless @disableNext()}, "Next"
      div {className: 'clear-both'}
