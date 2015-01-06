auth = require './auth'
React = require 'react'
AuthBar = require './components/AuthBar/AuthBar.view'
Routes = require './client-routes'

LoadingScreen = React.createClass
  displayName: 'LoadingScreen'
  render: ->
    React.DOM.div({}, 'Loading')

addMiddleware = (route) ->
  page route[0], route[1]
  return

addPage = (route) ->
  url = route[0]
  Component = route[1]
  page url, (ctx) =>
    # Set the body class based on the current page
    document.querySelector('body').className = ['body', route[2]].filter(Boolean).join('-')
    document.title = "Domino - Change the world, one step at a time: #{route[2]}"

    # Scroll the window to the top each time a page gets shown
    window.scrollTo(0, 0)

    @setState
      component: Component
      params: ctx.params
      querystring: ctx.querystring
      user: ctx.user
      context: ctx

    return

  return

Router = React.createClass
  displayName: 'Router'

  componentDidMount: ->
    @props.routes.middleware.forEach addMiddleware.bind(this)
    @props.routes.pages.forEach addPage.bind(this)

    auth.on 'authStateChange', @setUserState

    page.start()
    return

  componentWillUnmount: ->
    auth.removeListener 'authStateChange', @setUserState

  setUserState: ->
    if @isMounted()
      @setState user: auth.user

  getInitialState: ->
    component: LoadingScreen
    params: {}
    querystring: null
    user: null
    context: {}

  render: ->
    React.DOM.div {},
      unless @state.component.displayName == 'EmailLoginRegister'
        new AuthBar loggedIn: auth.loggedIn
      new @state.component
          params: @state.params
          querystring: @state.querystring
          user: @state.user
          context: @state.context

app =
  start: () ->
    React.render new Router(routes: Routes), document.querySelector("body")

module.exports = app
