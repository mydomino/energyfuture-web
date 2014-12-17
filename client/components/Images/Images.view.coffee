{div, h2, p, img} = React.DOM

_ = require 'lodash'
Autolinker = require 'autolinker'

module.exports = React.createClass
  displayName: 'Images'

  isExternal: (url) ->
    /^(f|ht)tps?:\/\//i.test(url)

  imageSrc: (url) ->
    if @isExternal(url) then url else "/img/" + url

  render: ->
    images = @props.moduleContent
    return false if _.isEmpty images

    div {className: 'guide-module guide-module-images'},
      div {className: 'guide-module-content'},
        images.map (i) =>
          div {},
            img {key: "images-module-#{i}", className: "images-module-image", src: @imageSrc(i.link)}
            p {className: 'image-module-caption', dangerouslySetInnerHTML: {"__html": Autolinker.link(i.caption)}}
