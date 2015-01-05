React = require 'react'
{div, h2, dl, dt, dd} = React.DOM

_ = require 'lodash'
Autolinker = require 'autolinker'

module.exports = React.createClass
  displayName: 'FAQ'

  getDefaultProps: ->
    guide: null

  getInitialState: ->
    activeIndex: 0

  setActiveIndex: (idx) ->
    idx = null if idx == @state.activeIndex
    @setState activeIndex: idx

  render: ->
    faqs = @props.content
    return false if _.isEmpty(faqs)

    div {className: 'guide-module guide-module-faq'},
      h2 {className: 'guide-module-header'}, 'faq'
      div {className: 'guide-module-content'},
        dl {className: 'faq-list'},
          faqs.map (faq, idx) =>
            openClass = 'active' if idx == @state.activeIndex
            [
              dt {key: "faq#{idx}-question", className: openClass, onClick: @setActiveIndex.bind(this, idx)}, faq.question
              dd {key: "faq#{idx}-answer", className: openClass, dangerouslySetInnerHTML: {"__html": Autolinker.link(faq.answer)}}
            ]
