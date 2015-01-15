{div, h2, h3, p, em} = React.DOM
Layout = require '../../components/Layout/Layout.view'
NavBar = require '../../components/NavBar/NavBar.view'
ScrollTopMixin = require '../../mixins/ScrollTopMixin'

module.exports = React.createClass
  displayName: 'PrivacyPolicy'
  mixins: [ScrollTopMixin]
  render: ->
    new Layout {name: 'privacypolicy'},
      new NavBar user: @props.user, path: @props.context.pathname
      div {className: "privacy-container"},
        h2 { id: "privacy-header"}, "Privacy Policy"
        p {}, "Domino is your one-stop personal toolkit for cultivating clean, low-carbon living – while saving money. From changing your light bulbs to going solar and everything in between, Domino guides you through actions you can take to enhance your lifestyle. Your actions will also help clean our air and water, achieve energy independence, and vitalize our economy."
