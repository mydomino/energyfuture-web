{div, h2, p, img} = React.DOM
_ = require 'lodash'
UserCollection = require '../../models/UserCollection'

module.exports = React.createClass
  displayName: 'Tips'
  getDefaultProps: ->
    tips: []

  componentWillMount: ->
    @userColl = new UserCollection()
    @userColl.on 'sync', =>
      @forceUpdate()

  render: ->
    return false if _.isEmpty @props.tips
    div {className: "tips"},
      h2 {className: "tips-header"}, "local tips"
      p {className: "tips-subheader"}, "Have a suggestion? Add a tip"
      div {className: "tip-items"},
        _.map @props.tips, (t) =>
          u = @userColl?.getUserById(t.get('userId'))
          div {className: "tip"},
            p {className: "tip-content"}, t.get('content')
            if u
              {displayName, profile_image_url} = u
              div {className: "tip-profile"},
                img {src: profile_image_url, className: "tip-profile-image"}
                div {className: "tip-profile-details"},
                  div {className: "tip-display-name"}, displayName
                  div {className: "tip-location"}, t.get('location')
            else
              div {className: "tip-location-without-profile"}, t.get('location')
        div {className: "clear"}
