React = require 'react'
{div, img} = React.DOM

LoadingIcon = React.createClass
  displayName: 'LoadingIcon'
  render: ->
    div {className: 'loading-icon'},
      img {className: 'loading-icon-image', src: '/img/loading-icon.gif'}

module.exports = React.createFactory LoadingIcon
