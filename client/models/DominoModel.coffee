firebase = require '../firebase'
Emitter = require('events').EventEmitter

module.exports = class DominoModel extends Emitter
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
          @emit('sync')

  get: (attr) ->
    @attributes[attr]
