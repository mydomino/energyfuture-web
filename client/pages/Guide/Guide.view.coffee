{div, h2, p} = React.DOM

firebase = require '../../firebase'
Guide = require '../../models/Guide'
NavBar = require '../../components/NavBar/NavBar.view'
NewsletterSignup = require '../../components/NewsletterSignupForm/NewsletterSignupForm.view'
LoadingIcon = require '../../components/LoadingIcon/LoadingIcon.view'

module.exports = React.createClass
  displayName: 'Guide'
  getInitialState: ->
    guide: null

  componentWillMount: ->
    guide = new Guide(id: @props.params.id)
    guide.on "sync", =>
      if @isMounted()
        @setState guide: guide.attributes

  render: ->
    if @state.guide
      name = @state.guide.title
      summary = @state.guide.intro?.caption

    div {className: "page page-guide"},
      div {className: "container"},
        div {className: "container-padding"},
          new NavBar
          if !@state.guide
            new LoadingIcon
          else
            div {className: "guide"},
              div {className: "guide-header"},
                h2 {}, name
                p {}, summary
              div {className: "guide-modules"},
                p {}, "Modules go here"
      div {className: 'footer'},
        new NewsletterSignup
