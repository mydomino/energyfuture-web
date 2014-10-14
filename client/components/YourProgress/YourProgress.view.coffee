{div, h2, p, span, ul, li} = React.DOM

module.exports = React.createClass
  displayName: 'YourProgress'
  render: ->
    div {className: "your-progress"},
      div {className: "your-progress-bar"},
        span {style: {width: "#{@props.goalReduction}%"}}

      h2 {}, "your progress"
      p {className: "sub-heading"}, "Powered by the UC Berkeley CoolClimate Calculator"
      ul {},
        li {},
          p {className: "guide-progress"}, "40%"
          div {className: "guide-progress-col"},
            div {style: {"height": "10%"}}
            div {className: "striped", style: {"height": "40%"}},
              div {className: "category-name"}, "Mobility"
            div {className: "solid"},
              ul {},
                li {},
                  span {className: "item-point"}
                  span {className: "item-text"}, "Go Electric"
                li {},
                  span {className: "item-point"}
                  span {className: "item-text"}, "Use Public Transportation"
        li {},
          p {className: "guide-progress"}, "30%"
          div {className: "guide-progress-col"},
            div {style: {"height": "20%"}}
            div {className: "striped", style: {"height": "30%"}},
              div {className: "category-name"},
            div {className: "solid"}
        li {},
          p {className: "guide-progress"}, "50%"
          div {className: "guide-progress-col"},
            div {style: {"height": "0%"}}
            div {className: "striped", style: {"height": "50%"}},
              div {className: "category-name"},
            div {className: "solid"}
        li {},
          p {className: "guide-progress"}, "50%"
          div {className: "guide-progress-col"},
            div {style: {"height": "0%"}}
            div {className: "striped", style: {"height": "50%"}},
              div {className: "category-name"},
            div {className: "solid"}
        li {},
          p {className: "guide-progress"}, "50%"
          div {className: "guide-progress-col"},
            div {style: {"height": "0%"}}
            div {className: "striped", style: {"height": "50%"}},
              div {className: "category-name"},
            div {className: "solid"}

