{div, h2, p, hr} = React.DOM

_ = require 'lodash'
Guide = require '../../models/Guide'
TipCollection = require '../../models/TipCollection'
Mixpanel = require '../../models/Mixpanel'
Layout = require '../../components/Layout/Layout.view'
NavBar = require '../../components/NavBar/NavBar.view'
LoadingIcon = require '../../components/LoadingIcon/LoadingIcon.view'
ImpactSidebar = require '../../components/ImpactSidebar/ImpactSidebar.view'
GuideModules = require('../../components/GuideModules.coffee')()
auth = require '../../auth'

module.exports = React.createClass
  displayName: 'Guide'
  getInitialState: ->
    guide: null

  componentWillMount: ->
    @guide = new Guide(id: @props.params.id)
    @guide.on "sync", @setGuide

    @setGuide(@guide)
    debouncedMixpanelUpdate = _.debounce =>
      Mixpanel.emit('analytics.guide.view', {guide_id: @guide.id, distinct_id: auth.user?.id})
    , 2000
    , {leading: false, trailing: true}
    auth.on 'authStateChange', debouncedMixpanelUpdate
    debouncedMixpanelUpdate()

  componentDidUpdate: (props, state) ->
    if state.guide
      $('.mixpanel-affiliate-link').click Mixpanel.emit('analytics.affiliate.view')

  componentWillUnmount: ->
    @guide.removeListener 'sync', @setGuide

  setGuide: (guide) ->
    if guide.exists() && @isMounted
      @setState guide: guide

  hideModule: (name) ->
    $(@refs[name].getDOMNode()).hide()
    false

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
            div {className: "guide-header"},
              h2 {}, title
              p {}, summary
            div {className: "guide-modules"},
              if modules
                modules.map (module, idx) =>
                  moduleName = module.name
                  return if module.submodule?

                  if GuideModules[moduleName]
                    div {key: "#{moduleName}-#{idx}"},
                      new GuideModules[moduleName]
                        guide: @state.guide
                        content: module.content
                        onError: @hideModule.bind(@, moduleName)
                      hr {className: "h-divider"}
                  else
                    console.warn 'Missing module for', moduleName
