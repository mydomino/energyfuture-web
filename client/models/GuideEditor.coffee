DominoModel = require './DominoModel'

module.exports = class GuideEditor extends DominoModel
  url: -> "/editor-metadata/tasks"

  wrap: (type, data) =>
    switch type
      when "Video"
        { source: "youtube", remote_id: data.videoUrl }
      when "Image"
        { file: { url: data[0] } }
      when "Collection"
        { text: _.map data, (e) -> e.content }
      else
        { text: "#{data}" }

  unwrap: (data) =>
    _.reduce data.data, ((acc, e) ->
      type = e.type
      i = switch type
        when "video"
          { intro: { videoUrl: e.data.remote_id } }
        when "collection"
          d = {}
          items = e.data.text.split("\n")
          d[e.data.heading] = _.map items, (i) -> { content: i.replace(/^ - (.+)$/mg,"$1") }
          d
        else
          d = {}
          d[e.data.heading] = e.data.text
          d
      _.merge(acc, i)
    ), {}

  editorJSON: (guide) =>
    guide = _.omit(guide, @attributes.untouchables)

    base =
      data: []

    _.each guide, (g, k) =>
      type = @attributes.type[k] || @attributes.type['default']

      put =
        type: type
        data:
          heading: k

      _.merge(put.data, @wrap(type, g))
      base.data.push(put)

    base
