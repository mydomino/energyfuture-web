React = require 'react'
{div, img} = React.DOM

DEFAULT_PHOTO_URL = '/* @echo ASSET_HOST_URL *//img/default-user-photo.png'

module.exports = React.createClass
  displayName: 'UserPhoto'
  propTypes:
    user: React.PropTypes.object

  render: ->
    div {className: 'user-photo'},
      img {src: @_photoUrl()}

  _photoUrl: ->
    (@props.user && @props.user.attributes.profile_image_url) || DEFAULT_PHOTO_URL
