{div, span, iframe} = React.DOM

# Defines what is required for this module to render
hasValidData = (content) ->
  return false unless content
  {videoUrl, imageUrl} = content
  return false unless imageUrl || videoUrl
  true

module.exports = React.createClass
  displayName: 'Intro'

  introStyle: (imageUrl, videoUrl) ->
    style = {}
    if imageUrl && !videoUrl
      style['background-image'] = "url(#{imageUrl})"
    style

  videoProps: (url) ->
    return unless url

    if url.indexOf('vimeo') > -1
      params = '?title=0&amp;byline=0&amp;portrait=0&amp;color=5ac1a0'
    else if url.indexOf('youtube') > -1
      params = '?modestbranding=1&controls=0&showinfo=0&color=white&theme=light'
    else
      params = ''

    src: url + params,
    frameBorder: 0
    allowFullScreen: true
    width: '100%'
    height: '100%'

  render: ->
    return null unless hasValidData(@props.content)

    {caption, duration, videoUrl, imageUrl} = @props.content

    div {className: 'guide-module-content'},
      div {className: "guide-module guide-module-intro", style: @introStyle(imageUrl, videoUrl)},
        if videoUrl
          div {className: "intro-video"},
            iframe @videoProps(videoUrl)
        if duration || caption
          div {className: "intro-overlay"},
            span {className: "intro-duration"}, duration
            span {className: "intro-title"}, caption
