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

  loadData: (snap) ->
    if snap && snap.val()
      data = snap.val()
      @loaded = true
      @models = data
      @deferred.resolve(data)

  sync: ->
    @_firebase().on 'value', (snap) => @loadData(snap)
    @deferred.promise

  syncOnce: ->
    @_firebase().once 'value', (snap) => @loadData(snap)
    @deferred.promise
