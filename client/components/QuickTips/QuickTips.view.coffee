{div, h2} = React.DOM
_ = require 'lodash'

Carousel = React.createFactory(require '../../components/Carousel/Carousel.view')

module.exports = React.createClass
  displayName: 'QuickTips'

  getDefaultProps: ->
    guide: null

  render: ->
    items = @props.content
    return false if _.isEmpty items

    div {className: "guide-module"},
      h2 {className: 'guide-module-header'}, "Quick tips"
      div {className: 'guide-module-content'},
        new Carousel items: items
