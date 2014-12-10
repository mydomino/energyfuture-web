module.exports =
  trackLinks: ->
    $(@trackingLinksContainer()).find('a').each (i, l) =>
      $(l).click(@onClickTrackingLink)

  componentDidMount: ->
    @trackLinks()
  
  componentDidUpdate: ->
    @trackLinks()
