{div, span, iframe} = React.DOM

module.exports = React.createClass
  displayName: 'Intro'
  getDefaultProps: ->
    caption: null
    duration: null
    videoUrl: null
    imageUrl: null

  introStyle: ->
    style = {}
    if @props.imageUrl && !@props.videoUrl
      style['background-image'] = "url(#{@props.imageUrl})"
    style

  videoProps: ->
    return unless @props.videoUrl

    if @props.videoUrl.indexOf('vimeo') > -1
      params = '?title=0&amp;byline=0&amp;portrait=0&amp;color=5ac1a0'
    else if @props.videoUrl.indexOf('youtube') > -1
      params = '?modestbranding=1&controls=0&showinfo=0&color=white&theme=light'
    else
      params = ''

    src: @props.videoUrl + params,
    frameBorder: 0
    allowFullScreen: true
    width: '100%'
    height: '100%'

  render: ->
    div {className: "intro", style: @introStyle()},
      if @props.videoUrl
        div {className: "video"},
          iframe @videoProps()
      if @props.duration || @props.caption
        div {className: "intro-overlay"},
          span {className: "intro-duration"}, @props.duration
          span {className: "intro-title"}, @props.caption
