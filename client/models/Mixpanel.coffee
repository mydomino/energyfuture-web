mixpanelToken = '/* @echo MIXPANEL_TOKEN */'
mixpanelFactory = require 'mixpanel'

module.exports =
  _instance: ->
    @_mixpanel ||= mixpanelFactory.init(mixpanelToken)

  track: (event, opts) ->
    @_instance().track event, opts
