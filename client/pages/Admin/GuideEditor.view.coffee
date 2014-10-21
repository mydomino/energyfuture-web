{div, form, textarea, input} = React.DOM
Guide = require '../../models/Guide'
GuideEditor = require '../../models/GuideEditor'
EditorBlocks = require '../../models/EditorBlocks'

module.exports = React.createClass
  displayName: 'GuideEditor'

  getInitialState: ->
    guide: {}

  componentWillMount: ->
    @guide = new Guide(id: @props.params.id)
    @guide.on 'sync', =>
      if @isMounted()
        @setState guide: @guide

    @guideEditor = new GuideEditor
    @guideEditor.on 'sync', =>
      if @isMounted()
        @setState guideEditor: @guideEditor

  componentDidMount: ->
    SirTrevor.DEBUG = true

    new SirTrevor.Editor
      el: $(@refs.editor.getDOMNode())
      blockTypes: ["Item", "Image", "Video", "Collection", "Test"]
      blockTypeLimits:
        "Item": 0
        "Collection": 0
        "Video": 1
        "Test": 1

    $(@refs.editorForm.getDOMNode()).on "submit", (e) =>
      e.preventDefault()
      data = SirTrevor.getInstance().dataStore
      @guide.update(@guideEditor.unwrap(data))

  componentDidUpdate: (p, s) ->
    el = $(@refs.editor.getDOMNode())

    if !_.isEmpty(@state.guide) and !_.isEmpty(@state.guideEditor)
      el.text(JSON.stringify(@state.guideEditor.editorJSON(@state.guide.attributes)))
      SirTrevor.getInstance().reinitialize(el: el,
        blockTypes: ["Item", "Image", "Video", "Collection", "Test"],
        blockTypeLimits: { "Item": 0, "Collection": 0, "Video": 1, "Test": 1 })

  render: ->
    div {className: "container-padding guide-editor"},
      form {ref: "editorForm"},
        textarea {ref: "editor"}
        input {type: "submit", className: "save-guide", value: "✔"}
      input {className: "editor-info", value: "!"}
