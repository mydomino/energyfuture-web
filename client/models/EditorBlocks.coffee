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

  SirTrevor.Blocks.List.extend
    type: "collection"
    title: -> "Collection"
    editorHTML: -> template(templateDefaults)

    loadData: (data) ->
      @$inner.find('h2').text(data.heading)
      @getTextBlock().html "<ul>" + @makeHTML(data.text) + "</ul>"

    makeHTML: (data) ->
      (_.map data, (i) -> "<li>#{i.content}</li>").join("\n")

    toData: () ->
      dataObj = {}

      if @hasTextBlock()
        content = @getTextBlock().html()

        # turn the text into an array
        if content.length > 0
          items = SirTrevor.toMarkdown(content, @type).split("\n")
          dataObj.text = _.map items, (i) -> { content: i }

      # Set
      @setData dataObj unless _.isEmpty(dataObj)
)()

#
#  Intro block – video/image with captions
#
SirTrevor.Blocks.Intro = (->
  templateDefaults =
    caption: ""
    duration: ""
    videoIframe: ""

  template = (data) ->
    caption = data.caption || templateDefaults.caption
    duration = data.duration || templateDefaults.duration
    videoIframe = data.videoIframe || templateDefaults.videoIframe

    _.template(["
<div class='intro-inputs'>
  <input type='text' class='caption'  name='caption' placeholder='caption' value='<%= caption %>' />
  <input type='text' class='duration' name='duration' placeholder='duration' value='<%= duration %>' />
</div>
<%= videoIframe %>"], { caption: caption, duration: duration, videoIframe: videoIframe })

  SirTrevor.Blocks.Video.extend
    # more providers at https://gist.github.com/jeffling/a9629ae28e076785a14f
    providers:
      default:
        regex: /(http(s?):)|([\/|.|\w|\s])*\.(?:jpg|gif|png)/
        html: "<iframe src=\"{{remote_id}}\" width=\"580\" height=\"320\" frameborder=\"0\"></iframe>"

      vimeo:
        regex: /(?:http[s]?:\/\/)?(?:www.)?vimeo.com\/(.+)/
        html: "<iframe src=\"{{protocol}}//player.vimeo.com/video/{{remote_id}}?title=0&byline=0\" width=\"580\" height=\"320\" frameborder=\"0\"></iframe>"

      youtube:
        regex: /(?:http[s]?:\/\/)?(?:www.)?(?:(?:youtube.com\/watch\?(?:.*)(?:v=))|(?:youtu.be\/))([^&].+)/
        html: "<iframe src=\"{{protocol}}//www.youtube.com/embed/{{remote_id}}\" width=\"580\" height=\"320\" frameborder=\"0\" allowfullscreen></iframe>"

    type: "intro"
    title: -> "Intro"

    loadData: (data) ->
      return unless @providers.hasOwnProperty(data.source)

      @$inner.prepend("<h2>Intro</h2>")

      if @providers[data.source].square
        @$editor.addClass "st-block__editor--with-square-media"
      else
        @$editor.addClass "st-block__editor--with-sixteen-by-nine-media"

      embed_string = @providers[data.source].html.replace("{{protocol}}", window.location.protocol).replace("{{remote_id}}", data.remote_id).replace("{{width}}", @$editor.width()) # for videos that can't resize automatically like vine
      finalData = _.merge(data, { videoIframe: embed_string })
      @$editor.html(template(finalData))

    toData: () ->
      dataObj = {}

      # Add any inputs to the data attr
      if @$(":input").not(".st-paste-block").length > 0
        @$(":input").each (index, input) ->
          dataObj[input.getAttribute("name")] = input.value if input.getAttribute("name")

      # Set
      currentData = @getData()

      newData = if currentData.source == 'default'
        { imageUrl: currentData.remote_id, caption: currentData.caption}
      else
        { videoUrl: currentData.remote_id, caption: currentData.caption, duration: currentData.duration }

      dataObj.text = newData
      @setData dataObj unless _.isEmpty(dataObj)
)()
