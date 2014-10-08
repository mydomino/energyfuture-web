{div, p, a} = React.DOM

module.exports = React.createClass
  displayName: 'Splash'
  continue: ->
    page '/guides'
  render: ->
    div {className: "page page-splash"},
      p {}, 'Splash Page Content'
      a {onClick: @continue}, 'Continue'
