auth = require './auth'
React = require 'react'
ReactAsync = require 'react-async'
AuthBar = require './components/AuthBar/AuthBar.view'
Routes = require './routes'
History = require 'html5-history-api'

addMiddleware = (route) ->
  page route[0], route[1]

addPage = (route) ->
  url = route[0]
  Component = route[1]
  page url, (ctx) =>
    # Set the body class based on the current page
    document.querySelector('body').className = ['body', route[2]].filter(Boolean).join('-')

    sessionStorage.setItem('lastPageVisited', ctx.pathname) unless url is '/login'

    props =
      component: Component
      params: ctx.params
      context:
        pathname: ctx.pathname

    ReactAsync.prefetchAsyncState Component(props), (e, c) => React.render c, document.getElementById('app')

Router = React.createClass
  displayName: 'Router'

  componentDidMount: ->
    auth.on 'authStateChange', @setUserState

  componentWillUnmount: ->
    auth.removeListener 'authStateChange', @setUserState

  setUserState: ->
    if @isMounted()
      @setState user: auth.user

  getInitialState: ->
    user: undefined

  render: ->
    new @props.component
      params: @props.params
      user: @state.user
      context: @props.context

Router = React.createFactory Router

app =
  start: () ->
    Routes.middleware.forEach addMiddleware.bind(this)
    Routes.pages.forEach addPage.bind(this)
    page.start()

module.exports = app
