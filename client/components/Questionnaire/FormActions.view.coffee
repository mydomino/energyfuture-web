{div} = React.DOM

module.exports = React.createClass
  displayName: 'FormActions'

  getDefaultProps: ->
    page: 1
    totalPageCount: 1

  render: ->
    previousClass = if @props.page == 1 then 'disabled' else ''
    nextClass = if @props.page == @props.totalPageCount then 'disabled' else ''
    div {className: 'questionnaire-form-actions'},
      div {className: "previous #{previousClass}"}, "Previous"
      div {className: "next #{nextClass}"}, "Next"
      div {className: 'clear-both'}
