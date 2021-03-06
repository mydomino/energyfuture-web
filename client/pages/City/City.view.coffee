{div, h1, h2, p, br, em, a, img, button} = React.DOM
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
        if @state.activeTab == 'electric-cars'
            imageText = "Electric cars are clean, green money machines. Buyers have saved up to $13,500 with rebates and up to 70% on gas."
            buttonText = "Read the Electric Car guide"
            guideUrl = "/guides/1-0"
        else if @state.activeTab == 'solar'
            imageText = "There’s a new solar home every 4 minutes in the U.S., and the average Colorado home saves $1,068 a year going solar."
            buttonText = "Read the Solar guide"
            guideUrl = "/guides/5-0"
        else if @state.activeTab == 'clean-power'
            imageText = "Even if you can’t put solar panels on your roof, you can switch to 100% clean electricity with the Fort Collins Green Energy program."
            buttonText = "Read the Clean Power guide"
            guideUrl = "/guides/8-0"
        else if @state.activeTab == 'thermostats'
            imageText = "A thermostat controls half your home’s energy, so make sure you have a smart one!"
            buttonText = "Read the Smart Thermostats guide"
            guideUrl = "/guides/3-4"

        new Layout {name: 'city', showFooter: false},
            #new NavBar user: @props.user, path: @props.context.pathname
            div {className: "city-container"},
                div {className: "city-container-head"},
                    div {className: "city-head"},
                        a {className: "link-home", onClick: @viewGuides},
                            h1 {}, "Domino Fort Collins"
                        p {className: "city-domino-count"},
                            "dominos in"
                            br {}
                            " motion"

                div {className: "city-container-map #{mapPreviewClass}"},
                    div {className: "city-map"},
                        div {className: "city-map-image-mask"},
                            p {className: "city-map-image-text"}, imageText
                            button {className: "city-map-image-button", onClick: => page(guideUrl)}, buttonText
                        div {className: "city-map-tabs"},
                            div {className: "city-map-tab #{electricCarsClass}", onClick: => @setState activeTab: 'electric-cars'},
                                img {src: "/img/ev-counter.png", className: "city-map-tab-image"}
                                p {className: "city-map-tab-text"}, "Electric cars"
                            div {className: "city-map-tab #{solarClass}", onClick: => @setState activeTab: 'solar'},
                                img {src: "/img/solar-counter.png", className: "city-map-tab-image"}
                                p {className: "city-map-tab-text"}, "Solar powered homes"
                            div {className: "city-map-tab #{cleanEnergyClass}", onClick: => @setState activeTab: 'clean-power'},
                                img {src: "/img/clean-power-counter.png", className: "city-map-tab-image"}
                                p {className: "city-map-tab-text"}, "Clean Energy Program Enrollees"
                            div {className: "city-map-tab #{thermostatsClass}", onClick: => @setState activeTab: 'thermostats'},
                                img {src: "/img/thermostats-counter.png", className: "city-map-tab-image"}
                                p {className: "city-map-tab-text"}, "Smart thermostats"

                div {className: "city-container-data"},
                    div {className: "city-data"},
                        div {className: "city-data-metric"},
                            p {className: "city-stats"}, "1% Carbon-free"
                        div {className: "city-data-text"},
                            h2 {}, "Domino is a low-carbon movement"
                            p {},
                                "From switching lightbulbs to going solar and everything in between, every action has a "
                                em {}, "domino effect"
                                ". Domino guides you through actions you can take to enhance your lifestyle, help clean our air and water, achieve energy independence, and vitalize our economy."
                            p {className: "city-page-button"},
                                a {className: "city-get-started", onClick: @viewGuides}, "Get Started"

                div {className: "city-container-partners"},
                    div {className: "city-partners"},
                        h2 {}, "Domino partners in Fort Collins"
                        p {}, "We collaborated with several amazing partners to develop Domino, all with a similar mission of creating a planet worth preserving for the next generation."
                        div {className: "city-partner-logos"}, "Namaste Solar, Clean Energy Collective, Rocky Mountain Institute, The Solutions Project, Real Goods Solar"

                div {className: "city-container-action"},
                    div {className: "city-action"},
                        div {className: "city-action-metric"},
                            p {className: "city-stats"}, "2,461 dominos in motion"
                        div {className: "city-action-text"},
                            h2 {}, "It's your turn now"
                            p {},
                                "Every one of our recommended actions helps you "
                                em {}, "save money and crash your carbon footprint"
                                ". There is no downside (well, unless you’re a coal plant)."
                            p {className: "city-page-button"},
                                a {className: "city-get-started", onClick: @viewGuides}, "Get Started"

                div {className: "city-container-disclaimer"},
                    div {className: "city-disclaimer"},
                        p {},
                            "The Fort Collins carbon-free metric is based on the cumulative carbon impact of households that have undertaken one or more of Domino’s recommended actions. Data sources: Electric cars ("
                            a {href: "http://blog.aee.net/driving-electric-vehicle-adoption-in-northern-colorado"}, "Advanced Energy Economy"
                            "), Solar homes (Larimer County residential solar permits), Thermostats and Green Energy Program (Fort Collins Utilties). For privacy purposes, while map markers indicate accurate number of actions they do not indicate exact location of households that have undertaken the actions."
