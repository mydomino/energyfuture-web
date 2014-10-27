{div, h2, p} = React.DOM

firebase = require '../../firebase'
Guide = require '../../models/Guide'
NavBar = require '../../components/NavBar/NavBar.view'
NewsletterSignup = require '../../components/NewsletterSignupForm/NewsletterSignupForm.view'
LoadingIcon = require '../../components/LoadingIcon/LoadingIcon.view'
Incentives = require '../../components/Incentives/Incentives.view'

module.exports = React.createClass
  displayName: 'Guide'
  getInitialState: ->
    guide: null

  componentWillMount: ->
    firebaseRef = firebase.inst '/tasks/' + @props.params.id
    firebaseRef.on 'value', (snap) =>
      @setState guide: new Guide(snap.val())

  render: ->
    {name, summary} = @state.guide if @state.guide
    incentives = [
      {
        provider: "US Federal"
        amount: "7,500"
        type: "tax rebate"
        description: "Lorem Ipsum gysum fullsome awesome"
        reference: "http://google.com"
      }
      {
        provider: "State of California"
        amount: "3,500"
        type: "tax rebate"
        description: "Lorem Ipsum gysum fullsome awesome"
        reference: "http://google.com"
      }
      {
        provider: "PG&E"
        amount: "1,500"
        type: "cash rebate"
        description: "Lorem Ipsum gysum fullsome awesome"
        reference: "http://google.com"
      }
    ]


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
                new Incentives(incentives: incentives)
      div {className: 'footer'},
        new NewsletterSignup
