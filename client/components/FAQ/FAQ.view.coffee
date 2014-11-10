{div, h2, dl, dt, dd} = React.DOM

_ = require 'lodash'
Autolinker = require 'autolinker'

# Defines what is required for this module to render
hasValidData = (guide) ->
  return false unless guide
  return false if _.isEmpty guide.get('faq')
  true

module.exports = React.createClass
  displayName: 'FAQ'

  getDefaultProps: ->
    guide: null

  getInitialState: ->
    activeIndex: null

  setActiveIndex: (idx) ->
    idx = null if idx == @state.activeIndex
    @setState activeIndex: idx

  render: ->
    return false unless hasValidData @props.guide
    faqs = @props.guide.get('faq')

    div {className: 'guide-module guide-module-faq'},
      h2 {className: 'guide-module-header'}, 'faq'
      dl {className: 'faq-list'},
        faqs.map (faq, idx) =>
          openClass = 'active' if idx == @state.activeIndex
          [
            dt {key: "faq#{idx}-question", className: openClass, onClick: @setActiveIndex.bind(this, idx)}, faq.question
            dd {key: "faq#{idx}-answer", className: openClass, dangerouslySetInnerHTML: {"__html": Autolinker.link(faq.answer)}}
          ]
