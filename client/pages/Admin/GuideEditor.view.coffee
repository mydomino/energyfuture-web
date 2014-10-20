{div, form, textarea, input} = React.DOM
Guide = require '../../models/Guide'
GuideEditor = require '../../models/GuideEditor'

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
      blockTypes: ["Text", "Image", "Video", "List"]

    $(@refs.editorForm.getDOMNode()).on "submit", (e) =>
      e.preventDefault()
      data = SirTrevor.getInstance().dataStore
      alert JSON.stringify data

  componentDidUpdate: (p, s) ->
    el = $(@refs.editor.getDOMNode())

    if !_.isEmpty(@state.guide) and !_.isEmpty(@state.guideEditor)
      el.text(JSON.stringify(@state.guide.editorJSON()))
      SirTrevor.getInstance().reinitialize(el: el, blockTypes: ["Text", "Image", "Video", "List"])

  render: ->
    div {className: "container-padding guide-editor"},
      form {ref: "editorForm"},
        textarea {ref: "editor"}
        input {type: "submit", className: "save-guide", value: "Save"}
