auth = require '../auth'
Mixpanel = require '../models/Mixpanel'

module.exports =
  trackViewGuideAction: ->
    Mixpanel.track("View Guide", {guide_id: @guide.id, distinct_id: auth.user?.id})

  trackAffiliateAction: (e) ->
    Mixpanel.track("View Affliate Link", distinct_id: auth.user?.id)
