{div, h2, ul, li} = React.DOM

_ = require 'lodash'

module.exports = React.createClass
  displayName: 'FAQ'

  getDefaultProps: ->
    questions: []

  render: ->
    return false if _.isEmpty @props.questions
    div {className: "faq"},
      h2 {}, "faq"
      ul {},
        _.map @props.questions, (q) ->
          li {}, q
