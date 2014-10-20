SirTrevor.Blocks.Dtext = (->
  templateDefaults =
    heading: ""
  baseTemplate = _.template(["<h2> <%= heading %> </h2>
<div class=\"st-required st-text-block\" contenteditable=\"true\"></div>"])

  SirTrevor.Block.extend
    type: "dtext"
    title: ->
      i18n.t "blocks:text:title"

    editorHTML: baseTemplate(templateDefaults)
    icon_name: "text"
    loadData: (data) ->
      @$inner.find('h2').text(data.heading)
      @getTextBlock().html SirTrevor.toHTML(data.text, @type)
)()
