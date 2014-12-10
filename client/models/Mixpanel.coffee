mixpanelToken = '/* @echo MIXPANEL_TOKEN */'
mixpanelFactory = require 'mixpanel'
moment = require 'moment'

module.exports =
  _instance: ->
    @_mixpanel ||= mixpanelFactory.init(mixpanelToken, cross_subdomain_cookie: false)

  track: (event, opts) ->
    @_instance().track event, opts

  setUser: (user) ->
    @_instance().people.set user.id,
      $name: user.get('displayName')
