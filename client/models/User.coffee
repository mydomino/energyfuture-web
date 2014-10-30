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
