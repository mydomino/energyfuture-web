{div} = React.DOM

module.exports = React.createClass
  displayName: 'PaginateActions'

  getDefaultProps: ->
    page: 1
    totalPageCount: 1

  render: ->
    previousClass = if @props.page == 1 then 'disabled' else ''
    nextClass = if @props.page == @props.totalPageCount then 'disabled' else ''

    div {className: 'questionnaire-paginate-actions'},
      div {className: "previous #{previousClass}", onClick: @props.prevAction}, "Previous"
      div {className: "next #{nextClass}", onClick: @props.nextAction}, "Next"
      div {className: 'clear-both'}
