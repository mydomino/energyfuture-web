#
# Text Block with heading
#
SirTrevor.Blocks.Item = (->
  SirTrevor.Blocks.Text.extend
    template: (data) ->
      _.template("<h2><%= heading %></h2><div class=\"st-required st-text-block\" contenteditable=\"true\"></div>", data)
    heading: ->
      "Item"
    type: "item"
    title: -> "Item"
    editorHTML: -> @template(heading: @heading())

    loadData: (data) ->
      @$inner.find('h2').text(@heading())
      @getTextBlock().html SirTrevor.toHTML("#{data.text}", @type)
)()

SirTrevor.Blocks.Category = (->
  SirTrevor.Blocks.Item.extend
    type: "category"
    title: -> "Category"
    heading: -> "Category"
)()

SirTrevor.Blocks.Mapsearch = (->
  SirTrevor.Blocks.Item.extend
    type: "mapsearch"
    title: -> "Map Term"
    heading: -> "Map Search Term"
)()


SirTrevor.Blocks.Photosearch = (->
  SirTrevor.Blocks.Item.extend
    type: "photosearch"
    title: -> "Photo Term"
    heading: -> "Photo Search Term"
)()

SirTrevor.Blocks.Score = (->
  SirTrevor.Blocks.Item.extend
    type: "score"
    title: -> "Score"
    heading: -> "Score"
)()

SirTrevor.Blocks.Title = (->
  SirTrevor.Blocks.Item.extend
    type: "title"
    title: -> "Title"
    heading: -> "Title"
)()

#
#  Array List with heading
#
SirTrevor.Blocks.Items = (->
  SirTrevor.Blocks.List.extend
    template: (data) ->
      _.template("<h2><%= heading %></h2><div class=\"st-text-block st-required\" contenteditable=\"true\"><ul><li></li></ul></div>", data)
    heading: ->
      "Items"
    type: "items"
    title: -> "items"
    editorHTML: -> @template(heading: @heading())

    loadData: (data) ->
      @$inner.find('h2').text(@heading())
      @getTextBlock().html "<ul>" + @toHTML(data.text) + "</ul>"

    toHTML: (data) ->
      (_.map data, (i) -> "<li>#{i}</li>").join("\n")

    toMarkdown: (markdown) ->
      markdown.replace(/<\/li>/mg, "\n").replace(/<\/?[^>]+(>|$)/mg, "").replace /^(.+)$/mg, "$1"

    toData: () ->
      dataObj = {}

      if @hasTextBlock()
        content = @getTextBlock().html()

        # turn the text into an array
        if content.length > 0
          dataObj.text = _.compact(@toMarkdown(content).split("\n"))

      # Set
      @setData dataObj unless _.isEmpty(dataObj)
)()

SirTrevor.Blocks.Upsides = (->
  SirTrevor.Blocks.Items.extend
    type: "upsides"
    title: -> "Upsides"
    heading: -> "Upsides"
)()

SirTrevor.Blocks.Downsides = (->
  SirTrevor.Blocks.Items.extend
    type: "downsides"
    title: -> "Downsides"
    heading: -> "Downsides"
)()

#
#  Unordered List with heading
#
SirTrevor.Blocks.Collection = (->
  SirTrevor.Blocks.List.extend
    template: (data) ->
      _.template("<h2><%= heading %></h2><div class=\"st-text-block st-required\" contenteditable=\"true\"><ul><li></li></ul></div>", data)
    heading: ->
      "Collection"
    type: "collection"
    title: -> "Collection"
    editorHTML: -> @template(heading: @heading())

    loadData: (data) ->
      @$inner.find('h2').text(@heading())
      @getTextBlock().html "<ul>" + @toHTML(data.text) + "</ul>"

    toHTML: (data) ->
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

SirTrevor.Blocks.Whattoknow = (->
  SirTrevor.Blocks.Collection.extend
    type: "whattoknow"
    title: -> "WhatToKnow"
    heading: -> "What To Know"
)()

SirTrevor.Blocks.Whatwelove= (->
  SirTrevor.Blocks.Collection.extend
    type: "whatwelove"
    title: -> "WhatWeLove"
    heading: -> "What We Love"
)()

SirTrevor.Blocks.Tips = (->
  SirTrevor.Blocks.Collection.extend
    type: "tips"
    title: -> "Tips"
    heading: -> "Tips"
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
    caption = data.text.caption || templateDefaults.caption
    duration = data.text.duration || templateDefaults.duration
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
      image:
        regex: /(http(s?):)|([\/|.|\w|\s])*\.(?:jpg|gif|png)/
        html: "<iframe src=\"{{remote_id}}\" width=\"580\" height=\"320\" frameborder=\"0\"></iframe>"

      video:
        regex: /(?:http[s]?:\/\/)?(?:www.)?(?:(?:youtube.com\/embed\/)|(?:youtu.be\/))([^&].+)/
        html: "<iframe src=\"{{protocol}}//www.youtube.com/embed/{{remote_id}}\" width=\"580\" height=\"320\" frameborder=\"0\" allowfullscreen></iframe>"

    type: "intro"
    title: -> "Intro"

    loadData: (data) ->
      @$inner.prepend("<h2>Intro</h2>")
      @$editor.addClass "st-block__editor--with-sixteen-by-nine-media"

      image = data.text.imageUrl
      video = data.text.videoUrl
      source = undefined
      url = undefined

      if image?
        source = 'image'
        url = image
      else if video?
        source = 'video'
        url = @providers[source].regex.exec(video)[1]

      # for videos that can't resize automatically like vine
      embed_string = @providers[source].html.replace("{{protocol}}", window.location.protocol).replace("{{remote_id}}", url).replace("{{width}}", @$editor.width())
      finalData = _.merge(data, { videoIframe: embed_string })

      @$editor.html(template(finalData))

    handleDropPaste: (url) ->
      return unless _.isURI(url)
      @setAndLoadData @rebuildData()

    rebuildData: () ->
      match = undefined
      _.each @providers, ((provider, index) ->
        data =
          text: {}
        match = provider.regex.exec(url)

        if match isnt null and not _.isUndefined(match[1])
          if index == 'image'
            _.merge(data.text, { imageUrl: url })
          else
            _.merge(data.text, { videoUrl: match[1] })

          return data
      ), this
)()
