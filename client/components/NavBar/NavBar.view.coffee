{div, h2, span, a, nav, img} = React.DOM
auth = require '../../auth'
UserPhoto = require '../UserPhoto/UserPhoto.view'

NavBarItem = React.createClass
  displayName: 'NavBarItem'
  getDefaultProps: ->
    active: false
    name: 'item'
    label: ''
    onClick: '/'
  render: ->
    classes = React.addons.classSet
      'nav-bar-item': true
      'float-right': true
      'active': @props.active

    classes = classes + " nav-bar-#{@props.name}"

    div {className: classes},
      a {className: "#{@props.name}-icon", onClick: @_handleClick },
        @props.children
        @props.label

  _handleClick: (e) ->
    e.preventDefault()

    if typeof @props.onClick == 'string'
      page(@props.onClick)
    else
      @props.onClick()

module.exports = React.createClass
  displayName: 'NavBar'
  getDefaultProps: ->
    guides: true
    long: false
    user: null
    path: null

  goHome: (event) ->
    event.preventDefault()
    page('/guides')

  render: ->
    nav {className: 'nav-bar'},
      div {className: 'nav-bar-logo float-left'},
        a {className: '', onClick: @goHome },
          img {src: '/img/mydomino_logo_universal.svg'}
      if @props.user
        new NavBarItem {name: 'user', label: @_userLinkText(), onClick: @_logout},
          new UserPhoto user: @props.user
      new NavBarItem name: 'footprint', label: 'My Impact', onClick: '/footprint', active: @_activeClass('/footprint')
      new NavBarItem name: 'guides', label: 'All Guides', onClick: '/guides', active: @_activeClass('/guides')

  _userLinkText: ->
    if @props.user then "Logout" else "Login"

  _activeClass: (name) ->
    @props.path && @props.path == name

  _logout: ->
    auth.logout() if @props.user
