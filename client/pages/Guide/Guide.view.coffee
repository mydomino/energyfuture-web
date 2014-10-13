{div, h2, p} = React.DOM

NavBar = require '../../components/NavBar/NavBar.view'
NewsletterSignup = require '../../components/NewsletterSignupForm/NewsletterSignupForm.view'
LoadingIcon = require '../../components/LoadingIcon/LoadingIcon.view'
data = require '../../sample-data'

module.exports = React.createClass
  displayName: 'Guide'
  getInitialState: ->
    guide: null

  componentWillMount: ->
    @setState guide: data.guides[@props.params.id - 1]

  render: ->
    {name, summary} = @state.guide if @state.guide

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
