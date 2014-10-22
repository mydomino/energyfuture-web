{div, h2, p} = React.DOM

firebase = require '../../firebase'
Guide = require '../../models/Guide'
NavBar = require '../../components/NavBar/NavBar.view'
UpsideDownside = require '../../components/UpsideDownside/UpsideDownside.view'
NewsletterSignup = require '../../components/NewsletterSignupForm/NewsletterSignupForm.view'
LoadingIcon = require '../../components/LoadingIcon/LoadingIcon.view'

module.exports = React.createClass
  displayName: 'Guide'
  getInitialState: ->
    guide: null

  componentWillMount: ->
    firebaseRef = firebase.inst '/tasks/' + @props.params.id
    firebaseRef.on 'value', (snap) =>
      @setState guide: new Guide(snap.val())

  render: ->
    {name, summary, upsides, downsides} = @state.guide if @state.guide

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
                new UpsideDownside(upsides: upsides, downsides: downsides)
      div {className: 'footer'},
        new NewsletterSignup
