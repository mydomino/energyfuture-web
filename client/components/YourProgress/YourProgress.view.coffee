{div, h2, p, span, ul, li} = React.DOM

_ = require 'lodash'

module.exports = React.createClass
  displayName: 'YourProgress'

  getDefaultProps: ->
    categorizedGuides: {}

  render: ->
    div {className: "your-progress"},
      div {className: "your-progress-header"},
        div {className: "your-progress-bar"},
          span {style: {width: "#{@props.goalReduction}%"}}

        h2 {}, "your progress"
        p {className: "sub-heading"}, "Powered by the UC Berkeley CoolClimate Calculator"
      ul {},
        _.map @props.categorizedGuides, (guides, category) ->
          li {},
            div {className: "guide-progress-col"},
              div {className: "guide-progress-upper"},
                div {className: "striped", style: {height: "100%"}},
                  span {className: "guide-progress-text"}, "39%"
                div {className: "guide-progress-completed", style: {height: "30%"}}
                div {className: "category-name"}, category
              div {className: "guide-progress-lower"},
                ul {},
                  _.map guides, (g) ->
                    li {},
                      span {className: "item-point"}
                      span {className: "item-text"}, g.name
