{div, h2, h4, p, dl, dt, dd, img, span} = React.DOM

_ = require 'lodash'
Autolinker = require 'autolinker'
GuideModules = require('../GuideModules')()

module.exports = React.createClass
  displayName: 'LeadingQuestion'

  getInitialState: ->
    activeSubmodule: @props.moduleContent.options[0].submodule

  setSubmodule: (module) ->
    unless module == @state.activeSubmodule
      @setState activeSubmodule: module

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
                    openClass = 'active' if submodule == @state.activeSubmodule

                    div {key: "option#{idx}", className: "option-button", onClick: @setSubmodule.bind(this, submodule)},
                      img {className: "option-button-image #{openClass}"}
                      p {className: "option-button-text"}, label

                  div {className: "clear-both"}

                if @state.activeSubmodule?
                  activeSubmodule = @props.guide.moduleByKey(@state.activeSubmodule)
                  new GuideModules[activeSubmodule?.name]
                    guide: @props.guide
                    moduleContent: activeSubmodule?.content
                    key: @state.activeSubmodule

            else
              console.warn("Did not understand the Leading Question type.")
