DominoModel = require './DominoModel'

module.exports = class GuideEditor extends DominoModel
  url: -> "/editor-meta/tasks"

  editorDataByType: (type, data) =>
    switch type
      when "Video"
        { source: "youtube", remote_id: data.videoUrl }
      when "Image"
        { file: { url: data[0] } }
      when "Collection"
        { text: _.map data, (e) -> e.content }
      else
        { text: "#{data}" }

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

      _.merge(put.data, @editorDataByType(type, g))
      base.data.push(put)

    base
