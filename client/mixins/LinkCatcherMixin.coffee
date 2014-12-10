module.exports =
  trackLinks: (node) ->
    $(node).find('a.mixpanel-affiliate-link').each (_, l) =>
      $(l).unbind('click').click(@onClickTrackingLink)

  componentDidMount: ->
    @trackLinks(@getDOMNode())

  componentDidUpdate: ->
    @trackLinks(@getDOMNode())
