{div, h2, p, img, a} = React.DOM

_ = require 'lodash'
UserCollection = require '../../models/UserCollection'
TipCollection = require '../../models/TipCollection'

DEFAULT_LIMIT = 3

TipProfile = React.createClass
  displayName: 'TipProfile'
  getDefaultProps: ->
    user: null
    location: ''

  render: ->
    if @props.user
      {displayName, profile_image_url} = @props.user

      div {className: "tip-profile"},
        img {src: profile_image_url, className: "tip-profile-image"}
        div {className: "tip-profile-details"},
          div {className: "tip-display-name"}, displayName
          div {className: "tip-location"}, @props.location
    else
      div {className: "tip-location-without-profile"}, @props.location

module.exports = React.createClass
  displayName: 'Tips'
  getDefaultProps: ->
    guide: null

  getInitialState: ->
    tips: []
    limit: DEFAULT_LIMIT

  componentWillMount: ->
    @userColl = new UserCollection()
    @userColl.on 'sync', =>
      if @isMounted()
        @forceUpdate()

    tipColl = new TipCollection()
    tipColl.on "sync", =>
      if @isMounted()
        @setState tips: tipColl.getTipsByGuide(@props.guide.id)

    if !_.isEmpty tipColl.models
      @setState tips: tipColl.getTipsByGuide(@props.guide.id)

  showAllTips: ->
    @setState limit: null

  hideAllTips: ->
    @setState limit: DEFAULT_LIMIT

  render: ->
    return false if _.isEmpty @state.tips

    tips = @state.tips
    tips = _.first(tips, @state.limit) if @state.limit

    div {className: "guide-module guide-module-tips"},
      h2 {className: "guide-module-header"}, "local tips"
      p {className: "guide-module-subheader"}, "Have a suggestion?"
      div {className: "guide-module-content tip-items"},
        _.map tips, (tip) =>
          {userId, content, location} = tip.attributes
          user = @userColl?.getUserById(userId)

          div {className: "tip", key: tip.id},
            p {className: "tip-content"}, content
            new TipProfile user: user, location: location
        div {className: "clear"}
      if @state.limit && @state.tips.length > @state.limit
        p {className: 'guide-module-show-all'},
          a {onClick: @showAllTips}, 'Show All Tips'
      else if @state.tips.length > DEFAULT_LIMIT
        p {className: 'guide-module-show-all'},
          a {onClick: @hideAllTips}, 'Show Only Top 3 Tips'
