_ = require 'lodash'
firebase = require '../firebase'
DominoModel = require './DominoModel'

module.exports = class Tip extends DominoModel
  url: -> "/tips/#{@id}"
