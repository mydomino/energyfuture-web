{div, h2, p} = React.DOM
ScrollTopMixin = require '../../mixins/ScrollTopMixin'

module.exports = React.createClass
  displayName: 'NotFound'
  mixins: [ScrollTopMixin]
  render: ->
    div {},
      h2 {}, "Page Not Found"
      p {}, "The page you tried to reach does not exist. Sorry about that."
