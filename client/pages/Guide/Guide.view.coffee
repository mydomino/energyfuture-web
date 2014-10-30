{div, h2, p, hr} = React.DOM

firebase = require '../../firebase'
Guide = require '../../models/Guide'
NavBar = require '../../components/NavBar/NavBar.view'
NewsletterSignup = require '../../components/NewsletterSignupForm/NewsletterSignupForm.view'
LoadingIcon = require '../../components/LoadingIcon/LoadingIcon.view'
DidYouKnow = require '../../components/DidYouKnow/DidYouKnow.view'
Fares = require '../../components/Fares/Fares.view'

module.exports = React.createClass
  displayName: 'Guide'
  getInitialState: ->
    guide: null

  componentWillMount: ->
    guide = new Guide(id: @props.params.id)
    guide.on "sync", =>
      if @isMounted()
        @setState
          guide: guide
          didYouKnows: guide.didYouKnows()

  render: ->
    if @state.guide
      attrs = @state.guide.attributes
      name = attrs.title
      summary = attrs.intro?.caption

    div {className: "page page-guide"},
      div {className: "container"},
        div {className: "container-padding"},
          new NavBar
          if !@state.guide
            new LoadingIcon
          else
            div {},
              div {className: "guide"},
                div {className: "guide-header"},
                  h2 {}, name
                  p {}, summary
                div {className: "guide-modules"},
                  hr {className: "h-divider"}
                  new DidYouKnow(items: @state.didYouKnows)
                  hr {className: "h-divider"}
                  new Fares()

      div {className: 'footer'},
        new NewsletterSignup
