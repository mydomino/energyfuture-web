firebase = require '../firebase'
Emitter = require('events').EventEmitter

module.exports = class DominoCollection extends Emitter
  _firebase: () ->
    @firebase || firebase.inst(@url())

  constructor: (opts = {}) ->
    super

    @firebase = opts.firebase
    @models = opts.models || {}
    @loaded = false

    @_firebase().on 'value', (snap) =>
      if snap
        @models = snap.val()
        @loaded = true
        @emit('sync')
