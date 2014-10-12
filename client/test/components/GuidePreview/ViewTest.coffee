ReactTestUtils = React.addons.TestUtils
GuidePreview = require "../../../components/GuidePreview/GuidePreview.view"
h = require "../../helpers"

describe "GuidePreview", ->
  it "renders a guide preview", () ->
    instance = ReactTestUtils.renderIntoDocument(GuidePreview(guide: { id: 1, name: 'Testing' }))

    h.classOccurs instance, 'guide-preview', 1

  it "accepts a customClass and appends it to the classes", () ->
    instance = ReactTestUtils.renderIntoDocument(GuidePreview(guide: { id: 1, name: 'Testing' }, customClass: 'new-class'))

    h.classOccurs instance, 'new-class', 1
