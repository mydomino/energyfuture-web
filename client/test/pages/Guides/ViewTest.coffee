Guides = require "../../../pages/Guides/Guides.view"
ReactTestUtils = React.addons.TestUtils
h = require "../../helpers"

describe "GuidesView", ->
  it "renders a guide preview for each guide", () ->
    guides = [
      { id: 1, name: 'testing' },
      { id: 2, name: 'testing' }
    ]
    instance = ReactTestUtils.renderIntoDocument(Guides(guides: guides))

    h.classOccurs instance, 'guide-preview', 2

  it "renders a long footprint icon", () ->
    instance = ReactTestUtils.renderIntoDocument(Guides())

    h.classOccurs instance, 'footprint-icon-long', 1


