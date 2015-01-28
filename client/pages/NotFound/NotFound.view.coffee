React = require 'react'
{div, h2, p} = React.DOM
ScrollTopMixin = require '../../mixins/ScrollTopMixin'

NotFound = React.createClass
  displayName: 'NotFound'
  mixins: [ScrollTopMixin]
  render: ->
    div {},
      h2 {}, "Page Not Found"
      p {}, "The page you tried to reach does not exist. Sorry about that."

module.exports = React.createFactory NotFound
