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
            p {}, "Lorem ipsum dolor sit amet, cu his falli placerat mnesarchum, unum fabellas est ea, sed ad elit noluisse."
            p {className: "city-page-button"},
              a {className: "city-get-started", onClick: @viewGuides}, "Get Started"
        div {className: "city-container-partners"},
          div {className: "city-partners"},
            h2 {}, "Domino partners in Fort Collins"
            div {className: "city-partner-logos"}, "Logo 1, Logo 2, Logo 3"
        div {className: "city-container-disclaimer"},
          div {className: "city-disclaimer"},
            p {}, "Bacon ipsum dolor amet bacon pork chop chuck tenderloin pork fatback rump bresaola jowl cow. Turkey kielbasa chicken, pork venison tenderloin pig frankfurter filet mignon doner hamburger andouille fatback. Porchetta pork loin pork biltong spare ribs turducken. Ground round andouille pastrami drumstick cupim beef t-bone porchetta tri-tip rump ribeye bresaola kielbasa chuck. Cupim prosciutto leberkas turkey, corned beef drumstick alcatra short ribs porchetta. Biltong sausage pig beef pancetta. Frankfurter alcatra ham hock pancetta short loin, prosciutto capicola tongue biltong hamburger tail swine bacon brisket jerky. Prosciutto pastrami andouille bresaola, tri-tip kielbasa beef ribs chuck picanha. Meatloaf tongue salami pork, boudin turducken venison. Ball tip flank ham picanha bresaola turducken brisket shank meatball meatloaf bacon porchetta.Ball tip turducken t-bone, pastrami kielbasa salami chicken tail beef ribs. Andouille beef ribs pork loin leberkas. Andouille turducken beef, ball tip t-bone sirloin cupim salami brisket. Flank ham hock chuck fatback brisket filet mignon rump, pork loin strip steak beef ribs spare ribs pork chop jowl. Brisket picanha porchetta, pork loin shankle beef venison biltong pancetta. Cow ham hock shoulder kielbasa short loin cupim turducken chicken pancetta meatball. Beef brisket porchetta ham capicola, tongue shankle venison.
"
