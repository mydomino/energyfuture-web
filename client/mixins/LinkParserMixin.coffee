auth = require '../auth'
Mixpanel = require '../models/Mixpanel'

module.exports =
  attachLink: ->
    console.log('clicked on the newly attached link on the anchor tag')

  componentDidMount: ->
    console.log('component did mount for the link parser module')

  componentDidUpdate: ->
    if @refs.linkContainer?
      self = @
      containerNode = @refs.linkContainer.getDOMNode()
      $(containerNode).find('a').each (_) ->
        $(@).click(self.attachLink)

