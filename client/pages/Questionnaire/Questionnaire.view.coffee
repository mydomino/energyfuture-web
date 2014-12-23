{div, iframe} = React.DOM

Layout = require '../../components/Layout/Layout.view'
NavBar = require '../../components/NavBar/NavBar.view'

module.exports = React.createClass
  displayName: 'Questionnaire'

  componentDidMount: ->
    $('body').append('<script src="https://s3-eu-west-1.amazonaws.com/share.typeform.com/widget.js"></script>')

  render: ->
    style =
    new Layout {name: 'questionnaire'},
      new NavBar user: @props.user, path: @props.context.pathname
      div {className: 'questionnaire-form'},
        iframe {id: "typeform-full", frameBorder: 0, src: "https://mydomino.typeform.com/to/peDQ9b?embed=full"}
