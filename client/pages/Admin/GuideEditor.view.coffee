{div, form, textarea} = React.DOM
Guide = require '../../models/Guide'

module.exports = React.createClass
  displayName: 'GuideEditor'

  getInitialState: ->
    guide: {}

  componentWillMount: ->
    @guide = new Guide(id: @props.params.id)
    @guide.on 'sync', =>
      if @isMounted()
        @setState guide: @guide

  componentDidMount: ->
    editor = new SirTrevor.Editor
      el: $(@refs.editor.getDOMNode())

  componentDidUpdate: (props, state) ->
    el = $(@refs.editor.getDOMNode())
    if !_.isEmpty @state.guide
      el.text(JSON.stringify(@state.guide.editorJSON()))
      SirTrevor.getInstance().reinitialize(el: el)

  render: ->
    div {className: "container-padding guide-editor"},
      form {},
        textarea {ref: "editor"}
