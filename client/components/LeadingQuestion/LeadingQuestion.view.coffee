{div, h2, h4, p, dl, dt, dd, img, span} = React.DOM

_ = require 'lodash'
Autolinker = require 'autolinker'
GuideModules = require('../GuideModules')()
HideModuleMixin = require '../../mixins/HideModuleMixin'

module.exports = React.createClass
  displayName: 'LeadingQuestion'
  mixins: [HideModuleMixin]

  getInitialState: ->
    activeOption: @props.content?.options[0]

  setActiveOption: (option) ->
    @setState activeOption: option unless _.isEqual(option, @state.activeOption)

  render: ->
    leadingQuestion = @props.content
    return false if _.isEmpty leadingQuestion
    {heading, subheading, content, question, options} = leadingQuestion

    div {className: 'guide-module guide-module-leading-question'},
      h2 {className: 'guide-module-header'}, (heading || "Take Action")
      p {className: 'guide-module-subheader', dangerouslySetInnerHTML: {"__html": Autolinker.link((subheading || ""))}}
      div {className: 'guide-module-content'},
        if content
          p {className: "leading-question-content"}, content
        if question
          p {className: "leading-question-question", dangerouslySetInnerHTML: {"__html": question}}

        dl {className: 'leading-question-list'},
          div {className: "results"},
            div {className: "options"},
              options.map (opt, idx) =>
                openClass = 'active' if _.isEqual(opt, @state.activeOption)

                div {key: "option#{idx}", className: "option-button #{openClass}", onClick: @setActiveOption.bind(this, opt)},
                  div {className: "option-button-text"},
                    p {className: "option-button-text-label"}, opt.label
                    p {className: "option-button-text-subtext"}, opt.subtext

              div {className: "clear-both"}

            if @state.activeOption?
              div {className: "leading-question-submodule"},
                _.map @state.activeOption.submodules, (sm, i) =>
                  activeSubmodule = @props.guide.moduleByKey(sm)
                  uniqName = "submodule-#{sm}-#{i}"
                  div {key: uniqName, ref: uniqName},
                    new GuideModules[activeSubmodule?.name]
                      guide: @props.guide
                      content: activeSubmodule?.content
                      onError: @hideModule.bind(@, uniqName)
