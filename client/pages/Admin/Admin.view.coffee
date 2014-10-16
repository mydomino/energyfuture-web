{div, a, h2} = React.DOM

_ = require 'lodash'
GuideCollection = require '../../models/GuideCollection'
Guide = require '../../models/Guide'
LoadingIcon = require '../../components/LoadingIcon/LoadingIcon.view'

module.exports = React.createClass
  displayName: 'Admin'
  getInitialState: ->
    guides: {}

  componentWillMount: ->
    guides = new GuideCollection
    guides.on 'sync', =>
      if @isMounted()
        @setState guides: guides.models

  pageAction: (event) ->
    page "/admin/guides/#{event.target.dataset.id}"

  render: ->
    div {className: "container-padding"},
      h2 {}, "Guides"
      if _.isEmpty @state.guides
        new LoadingIcon
      else
        _.map @state.guides, (g, _) =>
          a {className: "guide", onClick: @pageAction, "data-id": g.id}, new Guide(g).get('title')
