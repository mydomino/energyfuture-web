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


SirTrevor.Blocks.Dvideo = (->
  SirTrevor.Block.extend
    # more providers at https://gist.github.com/jeffling/a9629ae28e076785a14f
    providers:
      vimeo:
        regex: /(?:http[s]?:\/\/)?(?:www.)?vimeo.com\/(.+)/
        html: "<iframe src=\"{{protocol}}//player.vimeo.com/video/{{remote_id}}?title=0&byline=0\" width=\"580\" height=\"320\" frameborder=\"0\"></iframe>"

      youtube:
        regex: /(?:http[s]?:\/\/)?(?:www.)?(?:(?:youtube.com\/watch\?(?:.*)(?:v=))|(?:youtu.be\/))([^&].+)/
        html: "<iframe src=\"{{protocol}}//www.youtube.com/embed/{{remote_id}}\" width=\"580\" height=\"320\" frameborder=\"0\" allowfullscreen></iframe>"

    type: "video"

    title: ->
      i18n.t "blocks:video:title"

    droppable: true

    pastable: true

    icon_name: "video"

    loadData: (data) ->
      return  unless @providers.hasOwnProperty(data.source)
      if @providers[data.source].square
        @$editor.addClass "st-block__editor--with-square-media"
      else
        @$editor.addClass "st-block__editor--with-sixteen-by-nine-media"
      embed_string = @providers[data.source].html.replace("{{protocol}}", window.location.protocol).replace("{{remote_id}}", data.remote_id).replace("{{width}}", @$editor.width()) # for videos that can't resize automatically like vine
      @$editor.html embed_string

    onContentPasted: (event) ->
      @handleDropPaste $(event.target).val()

    handleDropPaste: (url) ->
      return unless _.isURI(url)
      match = undefined
      data = undefined
      _.each @providers, ((provider, index) ->
        match = provider.regex.exec(url)
        if match isnt null and not _.isUndefined(match[1])
          data =
            source: index
            remote_id: match[1]

          @setAndLoadData data
      ), this

    onDrop: (transferData) ->
      url = transferData.getData("text/plain")
      @handleDropPaste url
)()
