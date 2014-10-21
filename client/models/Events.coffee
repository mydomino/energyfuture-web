_ = require 'lodash'

module.exports = class Events
  constructor: (@callbacks = {}) ->

  on: (event, handler) ->
    @callbacks[event] ||= []
    @callbacks[event].push(handler)

  trigger: (event) ->
    _.each @callbacks[event], (callback) ->
      callback()
