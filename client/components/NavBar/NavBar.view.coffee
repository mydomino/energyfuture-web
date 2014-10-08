{div, h2, a} = React.DOM

module.exports = React.createClass
  displayName: 'NavBar'
  getDefaultProps: ->
    guides: true
    long: false
  render: ->
    div {className: 'nav-bar'},
      div {className: 'nav-bar-logo float-left'},
        a {className: 'site-logo', href: '/'}, "Domino"
      div {className: 'nav-bar-footprint float-right'},
        if @props.long
          a {className: 'footprint-icon footprint-icon-long', href: '/footprint' }, "Explore your footprint"
        else
          a {className: 'footprint-icon', href: '/footprint' }, "My Impact"
      if @props.guides && !@props.long
        div {className: 'nav-bar-guides float-right'},
          a {className: 'guides-icon', href: '/guides' }, "All Guides"
