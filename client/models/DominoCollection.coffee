firebase = require '../firebase'
Events = require './Events'

module.exports = class DominoCollection extends Events
  _firebase: () ->
    @firebase || firebase.inst(@url())

  constructor: (opts = {}) ->
    super

    @firebase = opts.firebase
    @models = opts.models || {}

    @_firebase().on 'value', (snap) =>
      if snap
        @models = snap.val()
        @trigger('sync')
