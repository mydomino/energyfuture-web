expect = require("chai").expect
IntroView = require "../../../pages/Splash/Splash.view"
ReactTestUtils = React.addons.TestUtils

describe "IntroView", ->
  it "redirects to the login page when the user clicks continue"
