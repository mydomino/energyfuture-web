{div, h2, h4, p, dl, dt, dd, img, span} = React.DOM

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
    activeIndex: 0

  setActive: (idx) ->
    idx = null if idx == @state.activeIndex
    @setState activeIndex: idx

  render: ->
    return false unless hasValidData @props.guide
    {heading, content, question, type, options} = @props.guide.get('leadingQuestion')

    div {className: 'guide-module guide-module-leading-question'},
      h2 {className: 'guide-module-header'}, (heading || "Take Action")
      div {className: 'guide-module-content'},
        if content
          p {className: "leading-question-content"}, content
        if question
          p {className: "leading-question-question #{type}"}, question

        dl {className: 'leading-question-list'},
          switch type
            when "radio"
              div {className: "radio-results"},
                div {className: "options"},
                  options.map (opt, idx) =>
                    point = opt.point
                    openClass = 'active' if idx == @state.activeIndex

                    div {className: "option-button", onClick: @setActive.bind(this, idx)},
                      img {className: "option-button-image #{openClass}"}
                      p {className: "option-button-text"}, point

                  div {className: "clear-both"}
                if @state.activeIndex?
                  p {className: "radio-result", dangerouslySetInnerHTML: {"__html": Autolinker.link(options[@state.activeIndex].result)}}

            when "bullet"
              options.map (opt, idx) =>
                point = opt.point
                openClass = 'active' if idx == @state.activeIndex

                [
                  dt {key: "option#{idx}-point", className: openClass, onClick: @setActive.bind(this, idx)}, point
                  dd {key: "option#{idx}-result", className: openClass, dangerouslySetInnerHTML: {"__html": Autolinker.link(opt.result)}}
                ]

            else
              console.warn("Did not understand the Leading Question type.")
