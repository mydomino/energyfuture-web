_ = require 'lodash'
auth = require '../auth'
Guide = require './Guide'

module.exports = class UserGuides
  constructor: (user, @status) ->
    @user = user || auth.user
    # init cache so that firebase bindings will set in by the time they are used
    @filteredGuides()

  filteredGuides: =>
    return [] unless @user
    @guides ||= _.reduce @user.get('guides'), ((_guides, guide, uniqId) =>
      _guides[uniqId] = new Guide(guide) if guide.status == @status
      _guides
    ), {}

  add: (guide) ->
    @user.addGuide(id: guide.id, status: @status)

  includesGuide: (guide) ->
    _.some @filteredGuides(), (_guide) => _guide.id == guide.id

  includesGuides: (groupGuideIds) ->
    ids = _.map @filteredGuides(), (guide) -> guide.id
    _.all groupGuideIds, (guideGroupGuideId) => _.contains(ids, guideGroupGuideId)

  includesGuideGroup: (guideGroup) ->
    _.some @filteredGuides(), (_guide) => _guide.get('guideGroupId') == guideGroup.id

  getPoints: ->
    _.reduce @filteredGuides(), ((total, guide) ->
      total += parseInt(guide.get('score'), 10)
      total
    ), 0
