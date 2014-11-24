{div, h2, p, hr} = React.DOM

_ = require 'lodash'
firebase = require '../../firebase'
Guide = require '../../models/Guide'
TipCollection = require '../../models/TipCollection'
Layout = require '../../components/Layout/Layout.view'
NavBar = require '../../components/NavBar/NavBar.view'
LoadingIcon = require '../../components/LoadingIcon/LoadingIcon.view'
ImpactSidebar = require '../../components/ImpactSidebar/ImpactSidebar.view'
GuideModules = require '../../components/GuideModules.coffee'

module.exports = React.createClass
  displayName: 'Guide'
  getInitialState: ->
    guide: null

  componentWillMount: ->
    guide = new Guide(id: @props.params.id)
    guide.on "sync", =>
      if @isMounted()
        @setState guide: guide

    @setState guide: guide

  render: ->
    if @state.guide
      {title, summary, category, intro} = @state.guide.attributes
      modules = @state.guide.modules()

    new Layout {name: 'guide'},
      new NavBar user: @props.user, path: @props.context.pathname
      if !@state.guide
        new LoadingIcon
      else
        div {},
          div {className: "guide"},
            if @props.user
              new ImpactSidebar
                user: @props.user
                guide: @state.guide
                category: category
            div {className: "guide-header"},
              h2 {}, title
              p {}, summary
            div {className: "guide-modules"},
              if modules
                modules.map (moduleName) =>
                  if GuideModules[moduleName]
                    div {key: moduleName},
                      new GuideModules[moduleName](guide: @state.guide)
                      hr {className: "h-divider"}
                  else
                    console.warn 'Missing module for', moduleName
