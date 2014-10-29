DominoModel = require './DominoModel'

module.exports = class GuideEditor extends DominoModel
  url: -> "/editor-metadata/tasks"

  wrap: (type, data) =>
    switch type
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
