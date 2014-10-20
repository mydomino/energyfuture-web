DominoModel = require './DominoModel'

module.exports = class GuideEditor extends DominoModel
  url: -> "/editor-meta/tasks"

  editorJSON: (guide) =>
    base =
      data: []

    _.each guide, (g, k) =>
      put =
        type: @attributes.type[k] || @attributes.type['default']
        data: g
      base.data.push(put)

    base
