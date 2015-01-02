{div, a, iframe} = React.DOM

module.exports = React.createClass
  displayName: 'TypeFormTrigger'
  propTypes:
    href: React.PropTypes.string.isRequired

  getDefaultProps: ->
    dataMode: 2
    href: null
    clickText: 'Launch me!'
    className: ''

  componentDidMount: ->
    $('body').append('<script src="https://s3-eu-west-1.amazonaws.com/share.typeform.com/share.js"></script>')

  render: ->
    a {className: "#{@props.className} typeform-share link", href: @props.href, 'data-mode': @props.dataMode, target: '_blank'}, @props.clickText
