{div, h2, h4, p, dl, dt, dd} = React.DOM

_ = require 'lodash'
Autolinker = require 'autolinker'

hasValidData = (guide) ->
  return false unless guide
  return false if _.isEmpty guide.get('leadingQuestion')
  true

module.exports = React.createClass
  displayName: 'LeadingQuestion'

  getDefaultProps: ->
    guide: null

  getInitialState: ->
    activeIndex: -1

  setActiveIndex: (idx) ->
    idx = null if idx == @state.activeIndex
    @setState activeIndex: idx

  render: ->
    return false unless hasValidData @props.guide
    {content, question, options} = @props.guide.get('leadingQuestion')

    div {className: 'guide-module guide-module-leading-question'},
      h2 {className: 'guide-module-header'}, 'Take Action'
      div {className: 'guide-module-content'},
        p {className: "leading-question-content"}, content
        h4 {className: "leading-question-question"}, question
        dl {className: 'leading-question-list'},
          options.map (opt, idx) =>
            openClass = 'active' if idx == @state.activeIndex
            [
              dt {key: "option#{idx}-point", className: openClass, onClick: @setActiveIndex.bind(this, idx)}, opt.point
              dd {key: "option#{idx}-result", className: openClass, dangerouslySetInnerHTML: {"__html": Autolinker.link(opt.result)}}
            ]
