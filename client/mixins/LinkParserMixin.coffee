module.exports =
  componentDidUpdate: ->
    $(@trackingLinksContainer()).find('a').each (i, l) => $(l).click(@onClickTrackingLink)
