{div, h2, h3, p, strong} = React.DOM
Layout = require '../../components/Layout/Layout.view'
NavBar = require '../../components/NavBar/NavBar.view'

module.exports = React.createClass
  displayName: 'AboutUs'
  render: ->
    new Layout {name: 'aboutus'},
      new NavBar user: @props.user, path: @props.context.pathname
      div {className: "about-us-container"},
        h2 { id: "we-re-reinventing-zero-emissions-living"}, "We’re reinventing zero-emissions living"
        p {}, "Domino is your one-stop personal toolkit for cultivating clean, low-carbon living – while saving money. From changing your light bulbs to going solar and everything in between, Domino guides you through actions you can take to enhance your lifestyle. Your actions will also help clean our air and water, achieve energy independence, and vitalize our economy."
        p {}, "How does it work? At Domino, we provide you a menu of options you can choose from to take action. In collaboration with the Rocky Mountain Institute (RMI), we've crunched the numbers and researched products and services to develop easy-to-understand, no-BS guides for you."
        p {}, "You can try an appetizer from our menu, and if you like it, go on to the main course. You can even sample the whole menu! Or you can try some items now, and leave some for later. It’s up to you how far you want to take your actions."
        h2 { id: "you-can-be-a-domino"}, "You can be a Domino"
        p {}, "Each action you take, no matter how small, helps create a much bigger effect – just like a stack of dominoes."
        p {}, "If you replace an old-style light bulb with an LED, that may seem like a very small action. But if 63 people replace a light bulb, that’s like taking one car off the road for an entire year. If those people replace all the bulbs in their home, we can make that 25 cars."
        p {}, "This is how you become a Domino – and vastly multiply the effect of each action you take."
        p {}, "We designed Domino to help you be part of the clean energy economy by taking one simple step at a time. You don’t need to wait for politicians or engineers to come up with solutions. We have the solutions now. Domino links you to the information and technology available today to power your home, travel to work, and make food choices for your family in a clean, low-cost, and lifestyle-enhancing way. We want to make it fun and easy for you to choose the changes that work for you. "
        p {}, "Together, we can create meaningful change locally, regionally, and globally – so our families and generations to come can thrive in a prosperous, abundant future."
        h2 { id: "we-are-dominoes"}, "We are Dominoes"
        p {}, "We created Domino2030 Inc. to help you make the changes that make sense for you. We want everyone to have a chance to benefit from the clean energy future. This is not just a job for us – it’s a mission."
        p {}, "As a California Public Benefits B Corporation, we define and drive our business based on more than just the interests of our shareholders. We also work for the public good of preserving a planet suitable for our children. The investors in Domino2030 fully support that greater good."
        h3 { id: "how-is-domino-supported-"}, "How is Domino supported?"
        p {}, "Domino is supported by multiple revenue sources: philanthropy, user donations, and lead referral fees. These fees are paid by technology or service providers for sales leads. The fees do not increase your costs. In fact, we lower the cost of services and technologies by making it cheaper for the vendors to acquire customers."
        p {}, "Domino shares up to 50% of our lead referral fees with schools, churches, and other facilitator organizations that are operating in your area. These organizations are helping Domino become a useful tool in improving the health and vitality of your community, while also helping to preserve our planet for our families and future generations.  "
        p {}, "By purchasing through our site, you support this important work."
        h3 { id: "our-partners"}, "Our partners"
        p {}, "We collaborated with several amazing partners to develop Domino:"
        p {},
          strong {}, "Facilitators: "
          "National and local organizations with a similar mission of creating a planet worth preserving for our children. National facilitator organizations include The Sierra Club, the Boy Scouts and Girl Scouts, and the World Wildlife Fund. Local Facilitators include the Pouter School System."
        p {},
          strong {}, "Rocky Mountain Institute (RMI): "
          "A clean-energy Think-and-Do Tank that has spent the past 30 years defining and tracking the best and latest low-carbon actions and technologies. RMI is located in Aspen and Boulder, Colorado. "
        p {},
          strong {}, "The Factory: "
          "A digital product incubator located in San Francisco – a bunch of really smart, nerdy, and creative folks who have fully redefined product development and the “cool workspace.” "
        p {},
          strong {}, "CoolClimate Network: "
          "Domino is a member of the CoolClimate Network, established by the University of California, Berkeley. The network provides supporting tools for households, businesses, local governments, and non-governmental organizations in customizing low-carbon action plans."
