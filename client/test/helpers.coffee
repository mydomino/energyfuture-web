expect = require("chai").expect
ReactTestUtils = React.addons.TestUtils

module.exports =
  classOccurs: (instance, cssClass, count) ->
    elm = ReactTestUtils.scryRenderedDOMComponentsWithClass(instance, cssClass)
    expect(elm).to.have.length(count)
