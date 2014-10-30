{div, h2, p, span, ul, li} = React.DOM

_ = require 'lodash'
LoadingIcon = require '../../components/LoadingIcon/LoadingIcon.view'

module.exports = React.createClass
  displayName: 'YourProgress'

  getDefaultProps: ->
    categorizedGuides: {}

  render: ->
    div {className: "your-progress"},
      div {className: "your-progress-header"},
        if !_.isEmpty @props.categorizedGuides
          div {className: "your-progress-bar"},
            span {style: {width: "#{@props.goalReduction}%"}}

        h2 {}, "your progress"
        p {className: "sub-heading"}, "Powered by the UC Berkeley CoolClimate Calculator"

      if !_.isEmpty @props.categorizedGuides
        div {},
          ul {className: "guides-upper"},
            _.map @props.categorizedGuides, (_, category) ->
              li {},
                div {className: "guide-progress"},
                  div {className: "striped", style: {height: "#{Math.floor((Math.random() * 80) + 20)}%"}},
                    span {className: "guide-progress-text"}, "39%"
                  div {className: "guide-progress-completed", style: {height: "15%"}}
                  div {className: "category-name"}, category

          _.map @props.categorizedGuides, (guides) ->
            div {className: "guide-list"},
              ul {},
                _.map guides, (g) ->
                  li {},
                    span {className: "item-point"}
                    span {className: "item-text"}, g.get('title')

          div {style: {clear: "both"}}
      else
        new LoadingIcon
