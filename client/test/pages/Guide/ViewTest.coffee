Guide = require "../../../pages/Guide/Guide.view"
ReactTestUtils = React.addons.TestUtils
h = require "../../helpers"

describe "GuidesView", ->
  it "renders a long footprint icon", () ->
    instance = ReactTestUtils.renderIntoDocument(Guides())

    h.classOccurs instance, 'footprint-icon-long', 1

  it "shows a loading icon if there is no guide", () ->
    instance = ReactTestUtils.renderIntoDocument(Guide())

    h.classOccurs instance, 'loading-icon', 1

  it "shows a loading icon if there is no guide", () ->
    instance = ReactTestUtils.renderIntoDocument(Guide())

    h.classOccurs instance, 'loading-icon', 1
