{div, h2, p, form, input, span} = React.DOM

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
    page: 1

  questionnaire: ->
    @state.guide.get('questionnaire')

  pickModule: ->
    _.find @questionnaire(), (q) => @state.page == q.position

  totalPageCount: ->
    _.max(_.pluck(@questionnaire(), "position"))

  isLastModule: ->
    @state.page == @totalPageCount()

  progressText:  ->
    return "complete" if @isLastModule()
    "#{@state.page} of #{@totalPageCount()}"

  componentWillMount: ->
    guide = new Guide(id: @props.params.guide_id)
    guide.on "sync", =>
      if @isMounted()
        @setState guide: guide

    @setState guide: guide

  nextAction: ->
    if @isMounted()
      @setState page: @state.page + 1

  prevAction: ->
    if @isMounted()
      @setState page: @state.page - 1

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
                div {className: 'questionnaire-progress-bar', style: {width: "#{(@state.page/_.size(questionnaire)) * 100}%"}},
                  span {className: "questionnaire-progress-bar-text #{"complete" if @isLastModule()}"}, @progressText()
              form {className: 'questionnaire-form'},
                new QuestionnaireModules[@pickModule().module](key: "component-#{@state.page}", guideId: @state.guide.id, moduleData: @pickModule(), nextAction: @nextAction, prevAction: @prevAction, page: @state.page, totalPageCount: @totalPageCount())
          else
            new LoadingIcon
