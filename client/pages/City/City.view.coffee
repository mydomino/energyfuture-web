{div, h1, h2, p, em, a, img} = React.DOM
Layout = require '../../components/Layout/Layout.view'
NavBar = require '../../components/NavBar/NavBar.view'
ScrollTopMixin = require '../../mixins/ScrollTopMixin'

module.exports = React.createClass
  displayName: 'City'
  mixins: [ScrollTopMixin]

  getInitialState: ->
    activeTab: 'electric-cars'

  componentWillMount: ->
    mixpanel.track 'View City Page'

  viewGuides: (event) ->
    event.preventDefault()
    page '/guides'

  render: ->
    electricCarsClass = React.addons.classSet active: @state.activeTab == 'electric-cars'
    solarClass = React.addons.classSet active: @state.activeTab == 'solar'
    cleanEnergyClass = React.addons.classSet active: @state.activeTab == 'clean-power'
    thermostatsClass = React.addons.classSet active: @state.activeTab == 'thermostats'
    mapPreviewClass = React.addons.classSet
      'electric-car-map': @state.activeTab == 'electric-cars'
      'solar-map': @state.activeTab == 'solar'
      'clean-power-map': @state.activeTab == 'clean-power'
      'thermostats-map': @state.activeTab == 'thermostats'
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
            div {className: "city-map-panes"},
              div {className: "city-map-tabs"},
                div {className: "city-map-tab #{electricCarsClass}", onClick: => @setState activeTab: 'electric-cars'},
                  img {src: "/img/ev-counter.png", className: "city-map-tab-image"}
                  p {className: "city-map-tab-text"}, "Electric cars"
                div {className: "city-map-tab #{solarClass}", onClick: => @setState activeTab: 'solar'},
                  img {src: "/img/solar-counter.png", className: "city-map-tab-image"}
                  p {className: "city-map-tab-text"}, "Solar powered homes"
                div {className: "city-map-tab #{cleanEnergyClass}", onClick: => @setState activeTab: 'clean-power'},
                  img {src: "/img/clean-power-counter.png", className: "city-map-tab-image"}
                  p {className: "city-map-tab-text"}, "Enrolled in Ft. Collins Clean Energy Program"
                div {className: "city-map-tab #{thermostatsClass}", onClick: => @setState activeTab: 'thermostats'},
                  img {src: "/img/thermostats-counter.png", className: "city-map-tab-image"}
                  p {className: "city-map-tab-text"}, "Smart thermostats"
              div {className: "city-map-image #{mapPreviewClass}"}, "Map goes here"
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
