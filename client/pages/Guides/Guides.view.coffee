{div, h1, button, br, span, img, p} = React.DOM

NavBar = require '../../components/NavBar/NavBar.view'
GuidePreview = require '../../components/GuidePreview/GuidePreview.view'
data = require '../../sample-data'

module.exports = React.createClass
  displayName: 'Guides'
  getDefaultProps: ->
    guides: data.guides
  render: ->
    div {className: "page page-guides"},
      div {className: "container"},
        div {className: "container-padding"},
          new NavBar long: true
          @props.guides.map (guide) ->
            new GuidePreview
              key: "guide#{guide.id}"
              guide: guide
