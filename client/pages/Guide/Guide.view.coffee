React = require 'react'
ReactAsync = require 'react-async'
{div, h1, p, hr, section, article, header} = React.DOM

_ = require 'lodash'
Guide = require '../../models/Guide'
TipCollection = require '../../models/TipCollection'
Layout = require '../../components/Layout/Layout.view'
NavBar = require '../../components/NavBar/NavBar.view'
LoadingIcon = require '../../components/LoadingIcon/LoadingIcon.view'
ImpactSidebar = require '../../components/ImpactSidebar/ImpactSidebar.view'
GuideModules = require('../../components/GuideModules.coffee')()
HideModuleMixin = require '../../mixins/HideModuleMixin'
ScrollTopMixin = require '../../mixins/ScrollTopMixin'
Autolinker = require 'autolinker'
auth = require '../../auth'

GuideView = React.createClass
  displayName: 'Guide'
  mixins: [HideModuleMixin, ReactAsync.Mixin, ScrollTopMixin]

  getInitialStateAsync: (cb) ->
    guide = new Guide(id: @props.params.id)
    guide.sync().then => cb null, { guide: guide }

  stateFromJSON: (state) ->
    guide: new Guide(state.guide.attributes)

  componentDidMount: ->
    @debouncedMixpanelUpdate = _.debounce(@updateMixpanel, 2000, {leading: false, trailing: true})
    auth.on 'authStateChange', @debouncedMixpanelUpdate
    @debouncedMixpanelUpdate()

  componentWillUnmount: ->
    auth.removeListener 'authStateChange', @debouncedMixpanelUpdate

  updateMixpanel: ->
    mixpanel.track("View Guide", {guide_id: @state.guide.id, distinct_id: auth.user?.id})

  rerenderComponent: ->
    @forceUpdate() if @isMounted()

  setGuide: (guide) ->
    if guide.exists() && @isMounted
      @setState guide: guide

  render: ->
    guide = @state.guide

    if guide
      {title, summary, category} = guide.attributes
      modules = guide.sortedModules()

    new Layout {name: 'guide', guideId: @props.params.id, showNewsletterSignup: true},
      new NavBar user: @props.user, path: @props.context.pathname
      if !guide
        new LoadingIcon
      else
        div {},
          div {className: "guide"},
            new ImpactSidebar
              user: @props.user
              guide: guide
              category: category

            header {className: "guide-header"},
              h1 {}, title
              if summary
                div {className: "guide-header-description", dangerouslySetInnerHTML: {"__html": Autolinker.link(summary)}}
            article {className: "guide-modules"},
              if modules
                modules.map (module, idx) =>
                  moduleName = module.name
                  return if module.submodule?

                  if GuideModules[moduleName]
                    uniqName = "#{moduleName}-#{idx}"
                    section {key: uniqName, ref: uniqName, id: module.id},
                      new GuideModules[moduleName]
                        guide: guide
                        content: module.content
                        onError: @hideModule.bind(@, uniqName)
                      hr {className: "h-divider"}
                  else
                    console.warn 'Missing module for', moduleName

module.exports = React.createFactory GuideView
