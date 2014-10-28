DominoModel = require './DominoModel'

module.exports = class GuideEditor extends DominoModel
  url: -> "/editor-metadata/tasks"

  wrap: (type, data) =>
    switch type
      when "Intro"
        image = data.imageUrl

        if image
          { source: "image", remote_id: image, caption: data.caption }
        else
          { source: "youtube", remote_id: data.videoUrl, caption: data.caption, duration: data.duration }
      when "Photo"
        { file: { url: data[0] } }
      else
        { text: data }

  unwrap: (data) =>
    _.reduce data.data, ((acc, e) ->

      d = {}
      d[e.data.heading] = e.data.text
      d

      _.merge(acc, d)
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
