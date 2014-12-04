mixpanelToken = '/* @echo MIXPANEL_TOKEN */'
mixpanelFactory = require 'mixpanel'
moment = require 'moment'

module.exports =
  _instance: ->
    @_mixpanel ||= mixpanelFactory.init(mixpanelToken)

  track: (event, opts) ->
    @_instance().track event, opts

  setUser: (user) ->
    @_instance().people.set user.id,
      $first_name: user.firstName()
      $last_name: user.lastName()
      $created: moment().toISOString()
