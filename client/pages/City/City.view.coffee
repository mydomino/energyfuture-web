{div, h1, h2, p, em, a} = React.DOM
Layout = require '../../components/Layout/Layout.view'
NavBar = require '../../components/NavBar/NavBar.view'
ScrollTopMixin = require '../../mixins/ScrollTopMixin'

module.exports = React.createClass
  displayName: 'City'
  mixins: [ScrollTopMixin]
  render: ->
    new Layout {name: 'city', showFooter: false},
      #new NavBar user: @props.user, path: @props.context.pathname
      div {className: "city-container"},
        div {className: "city-container-head"},
          div {className: "city-head"},
            h1 {}, "Domino Fort Collins"
            p {className: "city-stats"}, "1% Carbon-free"
            h2 {}, "Domino is a low-carbon movement"
            p {}, "From switching lightbulbs to going solar and everything in between, every action has a domino effect."
            p {className: "city-page-button"},
              a {className: "city-get-started", href: '/guides'}, "Get Started"
        div {className: "city-container-map"},
          div {className: "city-map"},
            h2 {}, "Fort Collins has 2,461 dominoes in motion"
            div {className: "city-map-selector"}, "Map goes here"
        div {className: "city-container-action"},
          div {className: "city-action"},
            h2 {}, "It's your turn now"
            p {}, "Lorem ipsum dolor sit amet, cu his falli placerat mnesarchum, unum fabellas est ea, sed ad elit noluisse."
            p {className: "city-page-button"},
              a {className: "city-get-started", href: '/guides'}, "Get Started"
        div {className: "city-container-partners"},
          div {className: "city-partners"},
            h2 {}, "Domino partners in Fort Collins"
            div {className: "city-partner-logos"}, "Logo 1, Logo 2, Logo 3"
