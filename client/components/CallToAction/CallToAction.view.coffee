{div, h2, h3, p, a, img} = React.DOM

_ = require 'lodash'

hasValidData = (guide) ->
  return false unless guide
  return false unless guide.get('cta')
  true

showMore = (event) ->
  $(event.target).parents('.action').css('max-height', 'none')
  $(event.target).parent('.action-read-more').hide()

module.exports = React.createClass
  displayName: 'CallToAction'

  getDefaultProps: ->
    guide: null

  componentDidMount: ->
    $(".guide-actions .action").each (_, action) ->
      if $(action).outerHeight() >= 240
        $(action).find('.action-read-more').show()

  render: ->
    return false unless hasValidData @props.guide
    cta = @props.guide.get('cta')

    div {},
      h2 {className: "guide-module-header"}, "What you can do"
      p {className: "guide-module-subheader"}, "Real tips from real people near you."
      div {className: 'guide-module-content'},
        div {className: 'guide-actions'},
          _.map cta, (action) ->
            div {className: "action"},
              h2 {className: "action-grouping"}, action.grouping
              a {href: action.reference, className: "action-title", target: "_blank"}, action.title
              p {className: "action-description"}, action.description
              div {className: 'action-read-more'},
                img {className : 'action-read-more-button', src: '/img/show-more.svg', onClick: showMore}
                div {className: 'action-read-more-mask'}
          div {className: "clear-both"}