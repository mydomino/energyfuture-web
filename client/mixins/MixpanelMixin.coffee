auth = require '../auth'
Mixpanel = require '../models/Mixpanel'

module.exports =
  componentDidUpdate: ->
    $(@trackingLinksContainer()).find('a').each (i, l) => $(l).click(@onClickTrackingLink)

  trackViewGuideAction: ->
    Mixpanel.track("View Guide", {guide_id: @guide.id, distinct_id: auth.user?.id})

  trackAffiliateAction: ->
    Mixpanel.track("View Affliate Link", distinct_id: auth.user?.id)
