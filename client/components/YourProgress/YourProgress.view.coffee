{div, h2, p, span, ul, li} = React.DOM

_ = require 'lodash'
LoadingIcon = require '../../components/LoadingIcon/LoadingIcon.view'

module.exports = React.createClass
  displayName: 'YourProgress'

  getDefaultProps: ->
    categorizedGuides: {}
    categorizedScores: {}
    totalScore: 0
    
  setCompletedProgress: (category, score) ->
    refItem = "progressCompletedFor#{category}"
    completed = score / @props.categorizedScores[category]
    progress  = Math.round(@categoryScore(category) * completed * 100)
    @refs[refItem].getDOMNode().style.height = "#{progress}%"

  categoryScore: (category) ->
    @props.categorizedScores[category] / @props.totalScore

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
            _.map @props.categorizedGuides, (_, category) =>
              catPerc = Math.round((@categoryScore(category)) * 100)

              li {},
                div {className: "guide-progress"},
                  div {className: "striped", style: {height: "#{catPerc}%"}},
                    span {className: "guide-progress-text"}, "#{catPerc}%"
                  div {className: "guide-progress-completed", ref: "progressCompletedFor#{category}"}
                  div {className: "category-name"}, category

          _.map @props.categorizedGuides, (guides) =>
            div {className: "guide-list"},
              ul {},
                _.map guides, (g) =>
                  li {onMouseEnter: @setCompletedProgress.bind(@, g.attributes.category, Number(g.attributes.score)), onMouseLeave: @setCompletedProgress.bind(@, g.attributes.category, Number(0))},
                    span {className: "item-point"}
                    span {className: "item-text"}, g.get('title')

          div {style: {clear: "both"}}
      else
        new LoadingIcon
