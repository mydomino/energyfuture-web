{div, h2, h4, p, dl, dt, dd, img, span} = React.DOM

_ = require 'lodash'
Autolinker = require 'autolinker'
GuideModules = require('../GuideModules')()

module.exports = React.createClass
  displayName: 'LeadingQuestion'

  getInitialState: ->
    activeSubmodules: @props.moduleContent.options[0].submodules

  setActiveSubmodules: (modules) ->
    unless _.isEqual(modules, @state.activeSubmodules)
      @setState activeSubmodules: modules

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
                    {label, submodules} = opt
                    openClass = 'active' if _.isEqual(submodules, @state.activeSubmodules)

                    div {key: "option#{idx}", className: "option-button", onClick: @setActiveSubmodules.bind(this, submodules)},
                      img {className: "option-button-image #{openClass}"}
                      p {className: "option-button-text"}, label

                  div {className: "clear-both"}

                if @state.activeSubmodules?
                  _.map @state.activeSubmodules, (sm, i) =>
                    activeSubmodule = @props.guide.moduleByKey(sm)
                    new GuideModules[activeSubmodule?.name]
                      guide: @props.guide
                      moduleContent: activeSubmodule?.content
                      key: "submodule-#{i}"

            else
              console.warn("Did not understand the Leading Question type.")
