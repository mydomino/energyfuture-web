_ = require 'lodash'
auth = require '../auth'
Mixpanel = require '../models/Mixpanel'

module.exports =
  trackAffiliateAction: (props = {}) ->
    Mixpanel.track "View Affliate Link", _.merge(props, distinct_id: auth.user?.id)
