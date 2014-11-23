_ = require 'lodash'
Emitter = require('events').EventEmitter

module.exports = class Events extends Emitter
  trigger: (event) ->
    @emit event
