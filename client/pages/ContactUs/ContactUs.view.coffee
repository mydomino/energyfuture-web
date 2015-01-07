React = require 'react'
{div, h2, h3, p, em} = React.DOM
Layout = require '../../components/Layout/Layout.view'
NavBar = require '../../components/NavBar/NavBar.view'

ContactUs = React.createClass
  displayName: 'ContactUs'
  componentDidMount: ->
    $('body').append('<script src="https://s3-eu-west-1.amazonaws.com/share.typeform.com/widget.js"></script>')
  render: ->
    style =
      'marginTop': 40
      'height': 500

    new Layout {name: 'contactus'},
      new NavBar user: @props.user, path: @props.context.pathname
      div {style: style, className: 'typeform-widget', 'data-url': 'https://mydomino.typeform.com/to/peDQ9b', 'data-text': 'Contact the team at Domino'}

module.exports = React.createFactory ContactUs
