#
# Text Block with heading
#
SirTrevor.Blocks.Item = (->
  templateDefaults =
    heading: ""
  template = _.template(["<h2><%= heading %></h2>
<div class=\"st-required st-text-block\" contenteditable=\"true\"></div>"])

  SirTrevor.Block.extend
    type: "item"
    title: -> "Item"
    editorHTML: template(templateDefaults)
    icon_name: "text"
    loadData: (data) ->
      @$inner.find('h2').text(data.heading)
      @getTextBlock().html SirTrevor.toHTML(data.text, @type)
)()

#
#  Unordered List with heading
#
SirTrevor.Blocks.Collection = (->
  templateDefaults =
    heading: ""
  template = _.template(["<h2><%= heading %></h2>
<div class=\"st-text-block st-required\" contenteditable=\"true\"><ul><li></li></ul></div>"])

  SirTrevor.Block.extend
    type: "collection"
    title: -> "Collection"
    icon_name: "list"
    editorHTML: -> template(templateDefaults)

    loadData: (data) ->
      @$inner.find('h2').text(data.heading)
      @getTextBlock().html "<ul>" + @toHTML(data.text) + "</ul>"

    onBlockRender: ->
      @checkForList = _.bind(@checkForList, this)
      @getTextBlock().on "click keyup", @checkForList

    checkForList: ->
      document.execCommand "insertUnorderedList", false, false  if @$("ul").length is 0

    toMarkdown: (markdown) ->
      markdown.replace(/<\/li>/mg, "\n").replace(/<\/?[^>]+(>|$)/mg, "").replace /^(.+)$/mg, " - $1"

    toHTML: (data) ->
      (_.map data, (i) -> "<li>#{i}</li>").join("\n")

    onContentPasted: (event, target) ->
      replace = @pastedMarkdownToHTML(target[0].innerHTML)
      @$("ul").html(replace)
      @getTextBlock().caretToEnd()

    isEmpty: ->
      _.isEmpty @saveAndGetData().text
)()
