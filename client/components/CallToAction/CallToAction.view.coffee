{div, h2, h3, p, a} = React.DOM

_ = require 'lodash'

hasValidData = (guide) ->
  return false unless guide
  return false unless guide.get('cta')
  true

module.exports = React.createClass
  displayName: 'CallToAction'

  getDefaultProps: ->
    guide: null

  render: ->
    return false unless hasValidData @props.guide
    cta = @props.guide.get('cta')

    div {},
      h2 {className: "guide-module-header"}, "What you can do"
      p {className: "guide-module-subheader"}, "Real tips from real people near you."
      div {className: 'guide-actions'},
        _.map cta, (action) ->
          div {className: "action"},
            h2 {className: "action-title"}, action.title
            _.map action.options, (o) ->
              div {className: "action-option"},
                h3 {className: "option-title"}, o.title
                p {className: "option-description"}, o.description
                a {href: o.reference, className: "option-reference"}, "Learn More"
        div {className: "clear-both"}