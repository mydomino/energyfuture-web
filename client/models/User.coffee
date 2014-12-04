_ = require 'lodash'
firebase = require '../firebase'
DominoModel = require './DominoModel'

module.exports = class User extends DominoModel
  url: -> "/users/#{@id}"

  constructor: (opts = {}) ->
    attrs = _.merge(opts, id: opts.uid)
    super(attrs)

  firstName: ->
    name = @get('displayName')
    return 'Friend' unless name
    return name.split(' ')[0]

  addGuide: (guide) ->
    @_firebase().child('guides').child(guide.id).set(guide)

  removeGuide: (guide) ->
    @_firebase().child('guides').child(guide.id).set(null)

  newsletterSignup: (email) ->
    @_firebase().update({newsletterEmail: email})

  isNewsletterRecipient: ->
    !!@get('newsletterEmail')

  ownership: ->
    @get('ownership') || 'own'

  updateOwnership: (ownership) ->
    @_firebase().update({'ownership': ownership})
