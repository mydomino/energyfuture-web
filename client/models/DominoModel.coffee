firebase = require '../firebase'
Q = require 'q'

module.exports = class DominoModel
  _firebase: () ->
    @firebase || firebase.inst(@url())

  constructor: (opts = {}) ->
    {@id, @firebase} = opts
    @attributes = opts || {}
    @deferred = Q.defer()
    @_firebaseBinding = opts.firebaseBinding || true

  sync: ->
    if @_firebaseBinding
      @_firebase().on 'value', (snap) =>
        if snap
          data = snap.val()
          @attributes = data
          @deferred.resolve(data)

    @deferred.promise

  get: (attr) ->
    @attributes[attr]
