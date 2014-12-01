auth = require './auth'
AuthBar = require './components/AuthBar/AuthBar.view'

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
    auth.on 'show-auth-prompt', @showAuthPrompt
    auth.on 'hide-auth-prompt', @hideAuthPrompt

    page.start()
    return

  componentWillUnmount: ->
    auth.removeListener 'authStateChange', @setUserState
    auth.removeListener 'show-auth-prompt', @showAuthPrompt
    auth.removeListener 'hide-auth-prompt', @hideAuthPrompt

  showAuthPrompt: ->
    if @isMounted()
      @setState authPrompt: true

  hideAuthPrompt: ->
    if @isMounted()
      @setState authPrompt: false

  setUserState: ->
    if @isMounted()
      @setState user: auth.user

  getInitialState: ->
    component: LoadingScreen
    params: {}
    querystring: null
    user: null
    context: {}
    authPrompt: false

  render: ->
    classes = if @state.authPrompt then 'auth-prompt' else ''

    React.DOM.div {className: classes},
      new AuthBar loggedIn: auth.loggedIn
      new @state.component
        params: @state.params
        querystring: @state.querystring
        user: @state.user
        context: @state.context

routes =
  middleware: [
    ["*", require('./middleware/authentication')]
    ["*", require('./middleware/categories')]
  ]
  pages:[
    ["/", require('./pages/Splash/Splash.view'), 'splash']
    ["/footprint", require('./pages/Footprint/Footprint.view'), 'footprint']
    ["/guides", require('./pages/Guides/Guides.view'), 'guides']
    ["/guides/:id", require('./pages/Guide/Guide.view'), 'guide']
    ["/guides/:guide_id/questionnaire", require('./pages/Questionnaire/Questionnaire.view'), 'guide']
    ["*", require('./pages/NotFound/NotFound.view'), 'not-found']
  ]

app =
  start: ->
    React.renderComponent new Router(routes: routes), document.querySelector("body")

module.exports = app
