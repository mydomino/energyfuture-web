ReactTestUtils = React.addons.TestUtils
GuidePreview = require "../../../components/GuidePreview/GuidePreview.view"
h = require "../../helpers"

describe "GuidePreview", ->
  it "renders a guide preview", () ->
    instance = ReactTestUtils.renderIntoDocument(GuidePreview(guide: { id: 1, name: 'Testing' }))

    h.classOccurs instance, 'guide-preview', 1
