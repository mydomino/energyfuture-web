{div, h2, p, hr} = React.DOM

firebase = require '../../firebase'
Guide = require '../../models/Guide'
NavBar = require '../../components/NavBar/NavBar.view'
NewsletterSignup = require '../../components/NewsletterSignupForm/NewsletterSignupForm.view'
LoadingIcon = require '../../components/LoadingIcon/LoadingIcon.view'
DidYouKnow = require '../../components/DidYouKnow/DidYouKnow.view'

module.exports = React.createClass
  displayName: 'Guide'
  getInitialState: ->
    guide: null

  componentWillMount: ->
    guide = new Guide(id: @props.params.id)
    guide.on "sync", =>
      if @isMounted()
        @setState guide: guide.attributes

  componentWillUpdate: (p, s)->
    $(".did-you-know").slick
      dots: true,
      infinite: true,
      speed: 300,
      slidesToShow: 1,
      adaptiveHeight: true

  render: ->
    $(".did-you-know").slick
      infinite: true,
      speed: 300,
      slidesToShow: 1,

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
            div {},
              div {className: "guide"},
                div {className: "guide-header"},
                  h2 {}, name
                  p {}, summary
                div {className: "guide-modules"},
                  p {}, "Modules go here"

              hr {className: "h-divider"}

              new DidYouKnow

              hr {className: "h-divider"}

      div {className: 'footer'},
        new NewsletterSignup
