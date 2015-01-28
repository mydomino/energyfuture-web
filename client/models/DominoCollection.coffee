firebase = require '../firebase'
Q = require 'q'

module.exports = class DominoCollection
  _firebase: () ->
    @firebase || firebase.inst(@url())

  constructor: (opts = {}) ->
    @firebase = opts.firebase
    @models = opts.models || {}
    @loaded = false
    @deferred = Q.defer()

  sync: ->
    @_firebase().on 'value', (snap) =>
      if snap
        data = snap.val()
        @loaded = true
        @models = data
        @deferred.resolve(data)

    @deferred.promise
