{div, h2, p, form, input} = React.DOM

_ = require 'lodash'
Guide = require '../../models/Guide'
LoadingIcon = require '../../components/LoadingIcon/LoadingIcon.view'
NavBar = require '../../components/NavBar/NavBar.view'
QuestionnaireModules = require '../../components/Questionnaire/QuestionnaireModules'

hasValidData = (guide) ->
  return false unless guide
  return false if _.isEmpty guide.get('questionnaire')
  true

module.exports = React.createClass
  displayName: 'Questionnaire'

  getInitialState: ->
    guide: null
    page: 2

  sortedFormModules: (questionnaire) ->
    _.sortBy(questionnaire, 'position')

  componentWillMount: ->
    guide = new Guide(id: @props.params.guide_id)
    guide.on "sync", =>
      if @isMounted()
        @setState guide: guide

    @setState guide: guide

  nextAction: ->
    if @isMounted()
      @setState page: page + 1

  render: ->
    {title, questionnaire} = @state.guide.attributes if hasValidData(@state.guide)
    div {className: "page"},
      div {className: "container"},
        div {className: "container-padding"},
          new NavBar
          if hasValidData(@state.guide)
            div {className: 'guide-module guide-module-questionnaire'},
              h2 {className: 'questionnaire-header'}, title
              div {className: 'questionnaire-progress-container'},
                div {className: 'questionnaire-progress-bar', style: {width: "#{(@state.page/_.size(questionnaire)) * 100}%"}}
              form {className: 'questionnaire-form'},
                _.map @sortedFormModules(questionnaire), (moduleData, index) =>
                  if index + 1 == @state.page
                    new QuestionnaireModules[moduleData.module](key: "component-#{index}", moduleData: moduleData, nextAction: @nextAction)

          else
            new LoadingIcon
