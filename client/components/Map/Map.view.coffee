{div, h2, p, img, a} = React.DOM

module.exports = React.createClass
  displayName: 'Map'

  render: ->
    div {className: 'guide-module guide-module-fares'},
      h2 {className: 'guide-module-header'}, 'route map'
      p {className: 'guide-module-subheader'},
        'Powered by '
        a {href: 'http://www.plugshare.com/' },
          'PlugShare'
      img {src: '/img/plugshare_ev_station_route_map.png'}
