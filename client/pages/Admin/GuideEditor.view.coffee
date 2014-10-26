{div, form, textarea, input} = React.DOM
Guide = require '../../models/Guide'
GuideEditor = require '../../models/GuideEditor'
EditorBlocks = require '../../models/EditorBlocks'

module.exports = React.createClass
  displayName: 'GuideEditor'

  getInitialState: ->
    guide: {}
    guideEditor: {}
    guideData: {}

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
    SirTrevor.DEBUG = false

    new SirTrevor.Editor
      el: $(@refs.editor.getDOMNode())
      blockTypes: ["Item", "Photos", "Intro", "Collection"]

    $(@refs.editorForm.getDOMNode()).on "submit", (e) =>
      e.preventDefault()
      data = SirTrevor.getInstance().dataStore
      info = @guideEditor.unwrap(data)
      @setState guideData: info
      @guide.update(info)

    $(@refs.backupForm.getDOMNode()).on "submit", (e) =>
      e.preventDefault()
      @saveBackup()

  loadFromBackup: ->
    guideData = JSON.parse(localStorage.getItem('adminBackup')).guides[@guide.id]
    el = $(@refs.editor.getDOMNode())
    el.text(JSON.stringify(guideData))
    SirTrevor.getInstance().reinitialize(el: el, blockTypes: ["Item", "Photos", "Intro", "Collection"])

  saveBackup: ->
    data = SirTrevor.getInstance().dataStore
    SirTrevor.onBeforeSubmit()
    localInfo = { guides: {} }
    localInfo.guides[@guide.id] = data
    localStorage.setItem 'adminBackup', JSON.stringify(localInfo)

  componentDidUpdate: (p, s) ->
    el = $(@refs.editor.getDOMNode())

    if !_.isEmpty(@state.guide) and !_.isEmpty(@state.guideEditor)
      el.text(JSON.stringify(@state.guideEditor.editorJSON(@state.guide.attributes)))
      SirTrevor.getInstance().reinitialize(el: el, blockTypes: ["Item", "Photos", "Intro", "Collection"])

  render: ->
    div {className: "container-padding guide-editor"},
      form {ref: "editorForm"},
        textarea {ref: "editor"}
        input {type: "submit", className: "publish-guide", value: "☁"}

      form {ref: "backupForm"},
        input {type: "submit", className: "save-guide", value: "✔"}

      input {className: "editor-info", value: "▼", onClick: @loadFromBackup}
