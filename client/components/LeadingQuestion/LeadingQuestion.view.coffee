{div, h2, h4, p, dl, dt, dd, img, span} = React.DOM

_ = require 'lodash'
Autolinker = require 'autolinker'
CallToAction = require '../CallToAction/CallToAction.view'

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

  setActive: (idx, content) ->
    idx = null if idx == @state.activeIndex

    @setState
      activeIndex: idx
      activeContent: content

  render: ->
    return false unless hasValidData @props.guide
    {content, question, type, options} = @props.guide.get('leadingQuestion')

    div {className: 'guide-module guide-module-leading-question'},
      h2 {className: 'guide-module-header'}, 'Take Action'
      div {className: 'guide-module-content'},
        if content
          p {className: "leading-question-content"}, content
        if question
          h4 {className: "leading-question-question"}, question
        dl {className: 'leading-question-list'},
          switch type
            when "radio"
              div {className: "radio-results"},
                div {className: "options"},
                  options.map (opt, idx) =>
                    point = opt.point
                    openClass = 'active' if idx == @state.activeIndex

                    div {className: "option-button", onClick: @setActive.bind(this, idx, opt.result)},
                      div {className: "option-button-image-container"},
                        img {className: "option-button-image #{openClass}"}
                      p {className: "option-button-text"},
                        point

                p {className: "radio-result"}, @state.activeContent

            when "bullet"
              options.map (opt, idx) =>
                point = opt.point
                openClass = 'active' if idx == @state.activeIndex

                [
                  dt {key: "option#{idx}-point", className: openClass, onClick: @setActive.bind(this, idx, opt.result)}, point
                  dd {key: "option#{idx}-result", className: openClass},
                    opt.result
                ]

            else
              console.log("Boohoo.")
