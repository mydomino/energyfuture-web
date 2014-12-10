module.exports =
  trackLinks: (node) ->
    $(node).find('a.mixpanel-external-link').each (_, l) =>
      $(l).unbind('click').click(@trackExternalLinkAction)

  componentDidMount: ->
    @trackLinks(@getDOMNode())

  componentDidUpdate: ->
    @trackLinks(@getDOMNode())
