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
      @getTextBlock().html "<ul>" + @makeHTML(data.text) + "</ul>"

    onBlockRender: ->
      @checkForList = _.bind(@checkForList, this)
      @getTextBlock().on "click keyup", @checkForList

    checkForList: ->
      document.execCommand "insertUnorderedList", false, false  if @$("ul").length is 0

    toMarkdown: (markdown) ->
      markdown.replace(/<\/li>/mg, "\n").replace(/<\/?[^>]+(>|$)/mg, "").replace /^(.+)$/mg, " - $1"

    makeHTML: (data) ->
      (_.map data, (i) -> "<li>#{i}</li>").join("\n")

    onContentPasted: (event, target) ->
      replace = @pastedMarkdownToHTML(target[0].innerHTML)
      @$("ul").html(replace)
      @getTextBlock().caretToEnd()

    isEmpty: ->
      _.isEmpty @saveAndGetData().text
)()

#
#  Intro block – video/image with captions
#
SirTrevor.Blocks.Intro = (->
  templateDefaults =
    caption: ""
    duration: ""
  template = (data) ->
    caption = data.caption || templateDefaults.caption
    duration = data.duration || templateDefaults.duration

    _.template(["
<br />
<div class='intro-inputs'>
  <input type='text' name='caption' placeholder='caption' value='<%= caption %>' />
  <br />
  <br />
  <input type='text' name='duration' placeholder='duration' value='<%= duration %>' />
</div>"], { caption: caption, duration: duration })

  SirTrevor.Block.extend
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
    droppable: true
    pastable: true
    icon_name: "video"

    loadData: (data) ->
      return unless @providers.hasOwnProperty(data.source)

      if @providers[data.source].square
        @$editor.addClass "st-block__editor--with-square-media"
      else
        @$editor.addClass "st-block__editor--with-sixteen-by-nine-media"

      embed_string = @providers[data.source].html.replace("{{protocol}}", window.location.protocol).replace("{{remote_id}}", data.remote_id).replace("{{width}}", @$editor.width()) # for videos that can't resize automatically like vine
      prepend_string = template(data)
      final = prepend_string + embed_string

      @$editor.html(final)

    onContentPasted: (event) ->
      @handleDropPaste $(event.target).val()

    handleDropPaste: (url) ->
      return unless _.isURI(url)
      match = undefined
      data = undefined
      _.each @providers, ((provider, index) ->
        match = provider.regex.exec(url)
        if match isnt null and not _.isUndefined(match[1])
          if index == 'default'
            data =
              source: index
              remote_id: url
          else
            data =
              source: index
              remote_id: match[1]

          @setAndLoadData data
      ), this

    onDrop: (transferData) ->
      url = transferData.getData("text/plain")
      @handleDropPaste url
)()

#
#  Photo block with heading
#
SirTrevor.Blocks.Photo  = SirTrevor.Block.extend(
  type: "photos"
  title: -> "Photos"
  droppable: true
  uploadable: true
  icon_name: "image"
  loadData: (data) ->

    # Create our image tag
    @$editor.html $("<img>",
      src: data.file.url
    )

  onBlockRender: ->
    # Setup the upload button
    @$inputs.find("button").bind "click", (ev) ->
      ev.preventDefault()

    @$inputs.find("input").on "change", _.bind((ev) ->
      @onDrop ev.currentTarget
    , this)

  onUploadSuccess: (data) ->
    @setData data
    @ready()

  onUploadError: (jqXHR, status, errorThrown) ->
    @addMessage i18n.t("blocks:image:upload_error")
    @ready()

  onDrop: (transferData) ->
    file = transferData.files[0]
    urlAPI = (if (typeof URL isnt "undefined") then URL else (if (typeof webkitURL isnt "undefined") then webkitURL else null))

    # Handle one upload at a time
    if /image/.test(file.type)
      @loading()

      # Show this image on here
      @$inputs.hide()
      @$editor.html($("<img>",
        src: urlAPI.createObjectURL(file)
      )).show()
      @uploader file, @onUploadSuccess, @onUploadError
)
