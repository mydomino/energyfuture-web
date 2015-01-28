React = require 'react'
{div, span, a, hr, i} = React.DOM

auth = require '../../auth'
UserGuides = require '../../models/UserGuides'
ImpactScore = require '../ImpactScore/ImpactScore.view'
FloatingSidebarMixin = require '../../mixins/FloatingSidebarMixin'

ImpactSidebar = React.createClass
  displayName: 'ImpactSidebar'
  mixins: [FloatingSidebarMixin]
  componentWillMount: ->
    @initUser()

  componentWillUnmount: ->
    if @props.user
      @props.user.removeListener 'sync', @setupState
    auth.removeListener 'authStateChange', @setupState

  getDefaultProps: ->
    category: ''
    guide: null
    user: null

  getInitialState: ->
    isClaimed: false
    isSaved: false

  initUser: ->
    if @props.user
      @setupState()
      @props.user.on 'sync', @setupState
    else
      auth.on 'authStateChange', @initUser

  setupState: ->
    return unless @props.user

    @savedForLater = new UserGuides(@props.user, 'saved')
    @claimedImpact = new UserGuides(@props.user, 'claimed')

    @setState @getCurrentState()

  getCurrentState: ->
    claimed = @claimedImpact?.includesGuide(@props.guide)
    saved = @savedForLater?.includesGuide(@props.guide)

    isClaimed: !!claimed
    isSaved: !!saved

  removeGuide: ->
    if @props.user
      @props.user.removeGuide @props.guide
    else
      auth.prompt(true)

  trackMixpanelAction: (action) ->
    mixpanel.track 'Impact Actions in Guides', action: action, guide: @props.guide.id

  claimGuide: ->
    action = =>
      @trackMixpanelAction('claimed')
      @claimedImpact.add(@props.guide)

    if @props.user
      action()
    else
      auth.prompt(true, action)

  saveGuide: ->
    action = =>
      @trackMixpanelAction('saved')
      @savedForLater.add(@props.guide)

    if @props.user
      action()
    else
      auth.prompt(true, action)

  render: ->
    claimedClass = if @state.isClaimed then 'active' else ''
    savedClass = if @state.isSaved then 'active' else if @state.isClaimed then 'disabled' else ''

    div {className: "impact-sidebar category-#{@props.category}", ref: 'sidebar'},
      new ImpactScore score: @props.guide.score()
      div {className: "impact-text"}, "Carbon-Free"
      hr {}
      div {className: "action-button #{claimedClass}"},
        if @state.isClaimed
          a {onClick: @removeGuide},
            i {className: "icon fa fa-check"}
            span {}, "Done"
        else
          a {onClick: @claimGuide},
            i {className: "icon fa fa-check"}
            span {}, "I did this"
      hr {}
      div {className: "action-button #{savedClass}"},
        if @state.isClaimed
          span {},
            i {className: "icon fa fa-star"}
            span {}, "Save for later"
        else if @state.isSaved
          a {onClick: @removeGuide},
            i {className: "icon fa fa-star"}
            span {}, "Saved for later"
        else
          a {onClick: @saveGuide},
            i {className: "icon fa fa-star"}
            span {}, "Save for later"

module.exports = React.createFactory ImpactSidebar
