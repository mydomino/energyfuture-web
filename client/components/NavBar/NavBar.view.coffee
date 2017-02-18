{div, h2, span, a, nav, img} = React.DOM
auth = require '../../auth'
UserPhoto = require '../UserPhoto/UserPhoto.view'

NavBarItem = React.createClass
  displayName: 'NavBarItem'
  getDefaultProps: ->
    active: false
    name: 'item'
    label: ''
    #onClick: '/'
    href: '/'
  render: ->
    classes = React.addons.classSet
      'nav-bar-item': true
      'float-right': true
      'active': @props.active

    classes = classes + " nav-bar-#{@props.name}"

    div {className: classes},
      a {className: "#{@props.name}-icon", href: @props.href },
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
        a {className: '', href: 'http://www.mydomino.com/myhome' },
          img {src: '/img/mydomino_logo_universal.svg'}
      if @props.user
        new NavBarItem {name: 'user', label: @_userLinkText(), onClick: @_logout},
          new UserPhoto user: @props.user
      # TODO(JP): Removing footprint page until we fix the percentage issue
      # new NavBarItem name: 'footprint', label: 'My Impact', onClick: '/footprint', active: @_activeClass('/footprint')
      # new NavBarItem name: 'guides', label: 'All Actions', onClick: '/guides', active: @_activeClass('/guides')
      new NavBarItem name: 'profile', label: 'Profile', href: 'https://www.mydomino.com/profile'
      new NavBarItem name: 'myhome', label: 'My Home', href: 'https://www.mydomino.com/myhome'

  _userLinkText: ->
    if @props.user then "Logout" else "Login"

  _activeClass: (name) ->
    @props.path && @props.path == name

  _logout: ->
    auth.logout() if @props.user
