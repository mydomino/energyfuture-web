DominoModel = require './DominoModel'

module.exports = class GuideEditor extends DominoModel
  url: -> "/editor-meta/tasks"

  editorDataByType: (type, data) =>
    switch type
      when "Video"
        { source: "youtube", remote_id: data.videoUrl }
      when "Image"
        { file: { url: data[0] } }
      when "List"
        { text: " - #{data.join("\n - ")}" }
      else
        { text: "#{data}" }

  editorJSON: (guide) =>
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
