module.exports =
  trackLinks: (node) ->
    $(node).find('a').each (i, l) =>
      $(l).unbind('click').click(@onClickTrackingLink)

  componentDidMount: ->
    @trackLinks(@getDOMNode())
  
  componentDidUpdate: ->
    @trackLinks(@getDOMNode())
