mixpanelToken = process.env.MIXPANEL_TOKEN || '/* @echo MIXPANEL_TOKEN */'
mixpanelFactory = require 'mixpanel'
moment = require 'moment'

module.exports =
  _instance: ->
    @_mixpanel ||= mixpanelFactory.init(mixpanelToken, cross_subdomain_cookie: false)

  track: (event, opts) ->
    @_instance().track event, opts

  signup: (userData) ->
    @_instance().people.set userData.id,
      $name: userData.name
      $created: moment().toISOString()
