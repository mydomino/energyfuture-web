DominoModel = require './DominoModel'

module.exports = class Guide extends DominoModel
  url: -> "/tasks/#{@id}"

  editorJSON: ->
    data: [
      {
        type: "dtext"
        data:
          heading: "title"
          text: @get('title')
      }
      {
        type: "dtext"
        data:
          heading: "caption"
          text: @get('intro').caption
      }
      {
        type: "video"
        data:
          source: "youtube"
          remote_id: @get("intro").videoUrl
      }
    ]
