React = require 'react'
{div, h2, p, img} = React.DOM

_ = require 'lodash'
Autolinker = require 'autolinker'
UserCollection = require '../../models/UserCollection'
TipCollection = require '../../models/TipCollection'

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

  componentWillMount: ->
    @userColl = new UserCollection()
    @userColl.on 'sync', =>
      if @isMounted()
        @forceUpdate()

    tipColl = new TipCollection()
    tipColl.on "sync", =>
      if @isMounted()
        @setState tips: _.sample(tipColl.getTipsByGuide(@props.guide.id), 3)

    if !_.isEmpty tipColl.models
      @setState tips: _.sample(tipColl.getTipsByGuide(@props.guide.id), 3)

  render: ->
    return false if _.isEmpty @state.tips

    div {className: "guide-module guide-module-tips"},
      h2 {className: "guide-module-header"}, "local tips"
      div {className: "guide-module-content tip-items"},
        _.map @state.tips, (tip) =>
          {userId, content, location} = tip.attributes
          user = @userColl?.getUserById(userId)

          div {className: "tip", key: tip.id},
            p {className: "tip-content", dangerouslySetInnerHTML: {"__html": Autolinker.link(content)}}
            new TipProfile user: user, location: location
        div {className: "clear-both"}
