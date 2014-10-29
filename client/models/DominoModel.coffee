firebase = require '../firebase'
Events = require './Events'

module.exports = class DominoModel extends Events
  _firebase: () ->
    @firebase || firebase.inst(@url())

  constructor: (opts = {}) ->
    super

    {@id, @firebase} = opts
    @attributes = opts || {}

    firebaseBinding = opts.firebaseBinding || true
    if firebaseBinding
      @_firebase().on 'value', (snap) =>
        if snap
          @attributes = snap.val()
          @trigger('sync')

  get: (attr) ->
    @attributes[attr]
