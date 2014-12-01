{div, h2, p, img} = React.DOM

_ = require 'lodash'
Autolinker = require 'autolinker'

hasValidData = (guide) ->
  return false unless guide
  return false if _.isEmpty guide.get('images')
  true

module.exports = React.createClass
  displayName: 'Images'

  getDefaultProps: ->
    guide: null

  isExternal: (url) ->
    /^(f|ht)tps?:\/\//i.test(url)

  imageSrc: (url) ->
    if @isExternal(url) then url else "/img/" + url

  render: ->
    return false unless hasValidData @props.guide
    images = @props.guide.get('images')

    div {className: 'guide-module guide-module-fares'},
      h2 {className: 'guide-module-header'}, 'Action Shots'
      p {className: 'guide-module-subheader', dangerouslySetInnerHTML: {"__html": Autolinker.link(images.subheading)}}
      div {className: 'guide-module-content'},
        images.links.map (i) => img {key: "images-module-#{i}", className: "images-module-image", src: @imageSrc(i)}
