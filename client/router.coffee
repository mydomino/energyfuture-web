auth = require './auth'
AuthBar = require './components/AuthBar/AuthBar.view'

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
      component: new Component params: ctx.params, querystring: ctx.querystring, user: ctx.user
      user: ctx.user
    return

  return

Router = React.createClass
  displayName: 'Router'
  componentDidMount: ->
    @props.routes.middleware.forEach addMiddleware.bind(this)
    @props.routes.pages.forEach addPage.bind(this)

    auth.on 'authStateChange', (data) =>
      @setState user: auth.user

    page.start()
    return

  getInitialState: ->
    component: React.DOM.div({}, 'Hello World')
    user: null

  render: ->
    React.DOM.div {},
      new AuthBar loggedIn: auth.loggedIn
      @state.component

routes =
  middleware: [
    ["*", require('./middleware/authentication')]
    ["*", require('./middleware/categories')]
  ]
  pages:[
    ["/", require('./pages/Splash/Splash.view'), 'splash']
    ["/footprint", require('./pages/Footprint/Footprint.view'), 'footprint']
    ["/guides", require('./pages/Guides/Guides.view'), 'guides']
    ["/guide/:id", require('./pages/Guide/Guide.view'), 'guide']
    ["/admin", require('./pages/Admin/Admin.view'), 'admin']
    ["/admin/guides/:id", require('./pages/Admin/GuideEditor.view'), 'guide-editor']
    ["*", require('./pages/NotFound/NotFound.view'), 'not-found']
  ]

app =
  start: ->
    React.renderComponent new Router(routes: routes), document.querySelector("body")

module.exports = app
