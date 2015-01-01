React = require 'react'
{div, img} = React.DOM

module.exports = React.createClass
  displayName: 'LoadingIcon'
  render: ->
    div {className: 'loading-icon'},
      img {className: 'loading-icon-image', src: '/img/loading-icon.gif'}
