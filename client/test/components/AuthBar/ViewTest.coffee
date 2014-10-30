ReactTestUtils = React.addons.TestUtils
AuthBar = require "../../../components/AuthBar/AuthBar.view"
h = require "../../helpers"

describe "AuthBar", ->
  it "renders the auth bar", () ->
    instance = ReactTestUtils.renderIntoDocument(AuthBar())

    h.classOccurs instance, 'auth-bar', 1

  it "does not render the auth bar if the user is present", () ->
    instance = ReactTestUtils.renderIntoDocument(AuthBar(user: true))

    h.classOccurs instance, 'auth-bar', 0
