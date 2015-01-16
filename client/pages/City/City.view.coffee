{div, h1, h2, p, em, a} = React.DOM
Layout = require '../../components/Layout/Layout.view'
NavBar = require '../../components/NavBar/NavBar.view'
ScrollTopMixin = require '../../mixins/ScrollTopMixin'

module.exports = React.createClass
  displayName: 'City'
  mixins: [ScrollTopMixin]

  componentWillMount: ->
    mixpanel.track 'View City Page'

  viewGuides: (event) ->
    event.preventDefault()
    page '/guides'

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
              a {className: "city-get-started", onClick: @viewGuides}, "Get Started"
        div {className: "city-container-map"},
          div {className: "city-map"},
            h2 {}, "Fort Collins has 2,461 dominoes in motion"
            div {className: "city-map-selector"}, "Map goes here"
        div {className: "city-container-action"},
          div {className: "city-action"},
            h2 {}, "It's your turn now"
            p {}, "Every one of our recommended actions helps you save money and crash your carbon footprint. There is no downside (well, unless you’re a coal plant)."
            p {className: "city-page-button"},
              a {className: "city-get-started", onClick: @viewGuides}, "Get Started"
        div {className: "city-container-partners"},
          div {className: "city-partners"},
            h2 {}, "Domino partners in Fort Collins"
            div {className: "city-partner-logos"}, "Logo 1, Logo 2, Logo 3"
        div {className: "city-container-disclaimer"},
          div {className: "city-disclaimer"},
            p {dangerouslySetInnerHTML: {"__html": "The Fort Collins carbon-free metric is based on the cumulative carbon impact of households that have undertaken one or more of Domino’s recommended actions.<br>Data sources - Electric cars (implied from http://blog.aee.net/driving-electric-vehicle-adoption-in-northern-colorado), Solar homes (Larimer County residential solar permits), Thermostats and Green Energy Program (Fort Collins Utilties). For privacy purposes, while map markers indicate accurate number of actions they do not indicate exact location of households that have undertaken the actions."}}
