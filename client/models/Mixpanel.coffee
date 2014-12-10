mixpanelToken = '/* @echo MIXPANEL_TOKEN */'
mixpanelFactory = require 'mixpanel'

_ = require 'lodash'
moment = require 'moment'
Emitter = require('events').EventEmitter

class Mixpanel extends Emitter
  constructor: ->
    @on 'analytics.login.openmodal', =>
      @track 'View Login Modal'
    @on 'analytics.login.userlogin', (opts) =>
      @track 'User Login', opts
    @on 'analytics.guide.view', (opts) =>
      @track "View Guide", opts
    @on 'analytics.questionnaire.view', (opts) =>
      @track "View Questionnaire", opts
    @on 'analytics.appointment.confirm', (opts) =>
      @track "Confirm Appointment", opts
    @on 'analytics.tips.signup', (opts) =>
      @track "Tips Signup", opts
    @on 'analytics.affiliate.click', (opts) =>
      @track "View Affliate Link", opts
    @on 'analytics.external.click', (opts) =>
      @track "View External Link", opts

  _instance: ->
    @_mixpanel ||= mixpanelFactory.init(mixpanelToken, cross_subdomain_cookie: false)

  track: (event, opts = {}) ->
    @_instance().track event, opts

  setUser: (user) ->
    @_instance().people.set user.id,
      $name: user.get('displayName')

module.exports = new Mixpanel
