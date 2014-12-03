ReactTestUtils = React.addons.TestUtils
NavBar = require "../../../components/NavBar/NavBar.view"
h = require "../../helpers"

describe "NavBar", ->
  it "renders the nav bar", () ->
    instance = ReactTestUtils.renderIntoDocument(NavBar())

    h.classOccurs instance, 'nav-bar', 1

  it "renders the guides icon", () ->
    instance = ReactTestUtils.renderIntoDocument(NavBar())

    h.classOccurs instance, 'guides-icon', 1

  it "renders the footprint icon", () ->
    instance = ReactTestUtils.renderIntoDocument(NavBar())

    h.classOccurs instance, 'footprint-icon', 1
