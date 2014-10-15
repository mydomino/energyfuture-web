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
          div {className: "guide-progress-col"},
            div {className: "guide-progress-col-empty", style: {height: "10%"}},
              span {className: "guide-progress-text"}, "40%"
            div {className: "striped", style: {height: "40%"}},
              div {className: "guide-progress-completed", style: {height: "80%"}}
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
          div {className: "guide-progress-col"},
            div {className: "guide-progress-col-empty", style: {height: "20%"}},
              span {className: "guide-progress-text"}, "20%"
            div {className: "striped", style: {height: "30%"}},
              div {className: "category-name"},
            div {className: "solid"}
        li {},
          div {className: "guide-progress-col"},
            div {className: "guide-progress-col-empty", style: {height: "0%"}},
              span {className: "guide-progress-text"}, "50%"
            div {className: "striped", style: {height: "50%"}},
              div {className: "category-name"},
            div {className: "solid"}
        li {},
          div {className: "guide-progress-col"},
            div {className: "guide-progress-col-empty", style: {height: "0%"}},
              span {className: "guide-progress-text"}, "50%"
            div {className: "striped", style: {height: "50%"}},
              div {className: "category-name"},
            div {className: "solid"}
        li {},
          div {className: "guide-progress-col"},
            div {className: "guide-progress-col-empty", style: {height: "0%"}},
              span {className: "guide-progress-text"}, "50%"
            div {className: "striped", style: {height: "50%"}},
              div {className: "category-name"},
            div {className: "solid"}

