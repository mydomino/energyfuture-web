{div, h2, h4, p, dl, dt, dd, img, span} = React.DOM

_ = require 'lodash'
Autolinker = require 'autolinker'
GuideModules = require '../GuideModules'
Amazon = require '../Amazon/Amazon.view'

module.exports = React.createClass
  displayName: 'LeadingQuestion'

  getInitialState: ->
    activeIndex: 0
    activeSubModule: @props.moduleContent.options[0].submodule

  setActive: (idx) ->
    idx = null if idx == @state.activeIndex
    @setState activeIndex: idx

  setSubModule: (module) ->
    unless module == @state.activeSubModule
      @setState activeSubModule: module

  render: ->
    leadingQuestion = @props.moduleContent
    return false if _.isEmpty leadingQuestion
    {heading, subheading, content, question, type, options} = leadingQuestion

    div {className: 'guide-module guide-module-leading-question'},
      h2 {className: 'guide-module-header'}, (heading || "Take Action")
      p {className: 'guide-module-subheader', dangerouslySetInnerHTML: {"__html": Autolinker.link((subheading || ""))}}
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
                    {label, submodule} = opt
                    openClass = 'active' if submodule == @state.activeSubModule

                    div {key: "option#{idx}", className: "option-button", onClick: @setSubModule.bind(this, submodule)},
                      img {className: "option-button-image #{openClass}"}
                      p {className: "option-button-text"}, label

                  div {className: "clear-both"}

                if @state.activeSubModule?
                  new Amazon
                    guide: @props.guide
                    moduleContent: @props.guide.moduleByKey(@state.activeSubModule)?.content
                    key: @state.activeSubModule

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
