{div, h2, p, iframe, a} = React.DOM

module.exports = React.createClass
  displayName: 'PlugShareMap'

  render: ->
    div {className: 'guide-module guide-module-plugshare'},
      h2 {className: 'guide-module-header'}, 'charging station map'
      p {className: 'guide-module-subheader'},
        'Powered by '
        a {href: 'http://www.plugshare.com/', target: '_blank'},
          'PlugShare'
      div {className: 'guide-module-content'},
        iframe {src:"http://www.plugshare.com/widget.html?latitude=&longitude=&spanLat=&spanLng="}
