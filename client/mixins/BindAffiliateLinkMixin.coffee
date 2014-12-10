module.exports =
  trackLinks: (node) ->
    $(node).find('a.mixpanel-affiliate-link').each (_, l) =>
      $(l).unbind('click').click(@trackAffiliateLinkAction)

  componentDidMount: ->
    @trackLinks(@getDOMNode())

  componentDidUpdate: ->
    @trackLinks(@getDOMNode())
