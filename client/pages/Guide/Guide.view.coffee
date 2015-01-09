{div, h1, p, hr, section, article, header} = React.DOM

_ = require 'lodash'
Guide = require '../../models/Guide'
TipCollection = require '../../models/TipCollection'
Mixpanel = require '../../models/Mixpanel'
Layout = require '../../components/Layout/Layout.view'
NavBar = require '../../components/NavBar/NavBar.view'
LoadingIcon = require '../../components/LoadingIcon/LoadingIcon.view'
ImpactSidebar = require '../../components/ImpactSidebar/ImpactSidebar.view'
GuideModules = require('../../components/GuideModules.coffee')()
HideModuleMixin = require '../../mixins/HideModuleMixin'
ScrollTopMixin = require '../../mixins/ScrollTopMixin'
auth = require '../../auth'

module.exports = React.createClass
  displayName: 'Guide'
  mixins: [HideModuleMixin, ScrollTopMixin]
  getInitialState: ->
    guide: null

  componentWillMount: ->
    @guide = new Guide(id: @props.params.id)
    @guide.on "sync", @setGuide

    @setGuide(@guide)
    @debouncedMixpanelUpdate = _.debounce(@updateMixpanel, 2000, {leading: false, trailing: true})
    auth.on 'authStateChange', @debouncedMixpanelUpdate
    @debouncedMixpanelUpdate()

  componentWillUnmount: ->
    @guide.removeListener 'sync', @setGuide
    auth.removeListener 'authStateChange', @debouncedMixpanelUpdate

  updateMixpanel: ->
    Mixpanel.track("View Guide", {guide_id: @guide.id, distinct_id: auth.user?.id})

  setGuide: (guide) ->
    if guide.exists() && @isMounted
      @setState guide: guide

  render: ->
    if @state.guide
      {title, summary, category} = @state.guide.attributes
      modules = @state.guide.sortedModules()

    new Layout {name: 'guide', guideId: @props.params.id, showNewsletterSignup: true},
      new NavBar user: @props.user, path: @props.context.pathname
      if !@state.guide
        new LoadingIcon
      else
        div {},
          div {className: "guide"},
            new ImpactSidebar
              user: @props.user
              guide: @state.guide
              category: category
            header {className: "guide-header"},
              h1 {}, title
              p {}, summary
            article {className: "guide-modules"},
              if modules
                modules.map (module, idx) =>
                  moduleName = module.name
                  return if module.submodule?

                  if GuideModules[moduleName]
                    uniqName = "#{moduleName}-#{idx}"
                    section {key: uniqName, ref: uniqName, id: module.id},
                      new GuideModules[moduleName]
                        guide: @state.guide
                        content: module.content
                        onError: @hideModule.bind(@, uniqName)
                      hr {className: "h-divider"}
                  else
                    console.warn 'Missing module for', moduleName
