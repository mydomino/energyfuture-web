ReactTestUtils = React.addons.TestUtils
GuidePreview = require "../../../components/GuidePreview/GuidePreview.view"
Guide = require "../../../models/Guide"
h = require "../../helpers"

guide = new Guide({ id: 1, name: 'Testing', category: 'energy' })

describe "GuidePreview", ->
  it "renders a guide preview", () ->
    instance = ReactTestUtils.renderIntoDocument(GuidePreview(guide: guide))

    h.classOccurs instance, 'guide-preview', 1

  it "accepts a customClass and appends it to the classes", () ->
    instance = ReactTestUtils.renderIntoDocument(GuidePreview(guide: guide, customClass: 'new-class'))

    h.classOccurs instance, 'new-class', 1
