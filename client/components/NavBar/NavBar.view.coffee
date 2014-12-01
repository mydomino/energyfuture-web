{div, h2, span, a} = React.DOM
auth = require '../../auth'
UserPhoto = require '../UserPhoto/UserPhoto.view'

module.exports = React.createClass
  displayName: 'NavBar'
  getDefaultProps: ->
    guides: true
    long: false
    user: null
    path: null

  render: ->
    div {className: 'nav-bar'},
      div {className: 'nav-bar-logo float-left'},
        a {className: 'site-logo', href: '/guides'}, "Domino"
      if @props.user
        div {className: 'nav-bar-item nav-bar-user float-right'},
          a {onClick: @_logout},
            new UserPhoto user: @props.user
            span {}, @_userLinkText()
      div {className: "nav-bar-item nav-bar-footprint float-right #{@_activeClass('/footprint')}"},
        a {className: 'footprint-icon', href: '/footprint' }, "My Impact"
      div {className: "nav-bar-item nav-bar-guides float-right #{@_activeClass('/guides')}"},
        a {className: 'guides-icon', href: '/guides' }, "All Guides"

  _userLinkText: ->
    if @props.user then "Logout" else "Login"

  _activeClass: (name) ->
    if @props.path && @props.path == name
      'active'
    else
      ''

  _logout: ->
    auth.logout() if @props.user
