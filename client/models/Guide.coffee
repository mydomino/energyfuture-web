firebase = require '../firebase'
DominoModel = require './DominoModel'

module.exports = class Guide extends DominoModel
  url: -> "/tasks/#{@id}"

  editorJSON: ->
    data: [
      {
        type: "text"
        data:
          text: @get('title')
      }
      {
        type: "text"
        data:
          text: @get('intro').caption
      }
      {
        type: "video"
        data:
          source: "youtube"
          remote_id: @get("intro").videoUrl
      }
    ]
