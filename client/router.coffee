Router = React.createClass
  displayName: 'Router'
  componentDidMount: ->
    self = this
    @props.routes.forEach (route) ->
      url = route[0]
      Component = route[1]
      page url, (ctx) ->
        # Set the body class based on the current page
        document.querySelector('body').className = ['body', route[2]].filter(Boolean).join('-')

        self.setState component: new Component params: ctx.params, querystring: ctx.querystring
        return

      return

    page.start()
    return

  getInitialState: ->
    component: React.DOM.div({}, 'Hello World')

  render: ->
    @state.component

routes = [
  ["/", require('./pages/Splash/Splash.view'), 'splash']
  ["/footprint", require('./pages/Footprint/Footprint.view'), 'footprint']
  ["/guides", require('./pages/Guides/Guides.view'), 'guides']
  ["/guide/:id", require('./pages/Guide/Guide.view'), 'guide']
  ["*", require('./pages/NotFound/NotFound.view'), 'not-found']
]

app =
  start: ->
    React.renderComponent new Router(routes: routes), document.querySelector("body")

module.exports = app
