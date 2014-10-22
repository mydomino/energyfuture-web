module.exports = class Guide
  constructor: (data) ->
    @id = data.id
    @name = data.title
    @summary = data.intro?.caption
    @recommended = data.recommended
    @preview_bg = data.photos?[0]
    @upsides = data.upsides
    @downsides = data.downsides
