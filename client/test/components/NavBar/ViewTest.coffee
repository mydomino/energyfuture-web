ReactTestUtils = React.addons.TestUtils
NavBar = require "../../../components/NavBar/NavBar.view"
h = require "../../helpers"

describe "NavBar", ->
  it "renders the nav bar", () ->
    instance = ReactTestUtils.renderIntoDocument(NavBar())

    h.classOccurs instance, 'nav-bar', 1

  it "renders the short version of the footprint icon", () ->
    instance = ReactTestUtils.renderIntoDocument(NavBar())

    h.classOccurs instance, 'footprint-icon', 1
    h.classOccurs instance, 'footprint-icon-long', 0

  it "renders the long version of the footprint icon if long is set", () ->
    instance = ReactTestUtils.renderIntoDocument(NavBar(long: true))

    h.classOccurs instance, 'footprint-icon-long', 1

  it "renders the short version of the guides icon", () ->
    instance = ReactTestUtils.renderIntoDocument(NavBar())

    h.classOccurs instance, 'guides-icon', 1

  it "does not render the guides icon if guides is set to false", () ->
    instance = ReactTestUtils.renderIntoDocument(NavBar(guides: false))

    h.classOccurs instance, 'guides-icon', 0

  it "does not render the guides icon if long is set to true", () ->
    instance = ReactTestUtils.renderIntoDocument(NavBar(long: true))

    h.classOccurs instance, 'guides-icon', 0
