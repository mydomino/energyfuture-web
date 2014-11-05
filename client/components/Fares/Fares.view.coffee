{div, h2, p, img} = React.DOM

module.exports = React.createClass
  displayName: 'Fares'

  render: ->
    div {className: 'guide-module guide-module-fares'},
      h2 {className: 'guide-module-header'}, 'fares'
      p {className: 'guide-module-subheader'}, 'Powered by SMFTA'
      img {src: '/img/fares.png'}
