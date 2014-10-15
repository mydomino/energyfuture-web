{div, h2, p, span, ul, li} = React.DOM

module.exports = React.createClass
  displayName: 'YourProgress'
  render: ->
    div {className: "your-progress"},
      div {className: "your-progress-header"},
        div {className: "your-progress-bar"},
          span {style: {width: "#{@props.goalReduction}%"}}

        h2 {}, "your progress"
        p {className: "sub-heading"}, "Powered by the UC Berkeley CoolClimate Calculator"
      ul {},
        li {},
          div {className: "guide-progress-col"},
            div {className: "guide-progress-upper"},
              div {className: "striped", style: {height: "100%"}},
                span {className: "guide-progress-text"}, "39%"
              div {className: "guide-progress-completed", style: {height: "30%"}}
              div {className: "category-name"}, "Mobility"

            div {className: "guide-progress-lower"},
              ul {},
                li {},
                  span {className: "item-point"}
                  span {className: "item-text"}, "Go Electric"
                li {},
                  span {className: "item-point"}
                  span {className: "item-text"}, "Use Public Transportation"
        li {},
          div {className: "guide-progress-col"},
            div {className: "guide-progress-upper"},
              div {className: "striped", style: {height: "75%"}},
                span {className: "guide-progress-text"}, "24%"
              div {className: "guide-progress-completed", style: {height: "30%"}}
              div {className: "category-name"}, "Mobility"

            div {className: "guide-progress-lower"},
              ul {},
                li {},
                  span {className: "item-point"}
                  span {className: "item-text"}, "Go Electric"
                li {},
                  span {className: "item-point"}
                  span {className: "item-text"}, "Use Public Transportation"
        li {},
          div {className: "guide-progress-col"},
            div {className: "guide-progress-upper"},
              div {className: "striped", style: {height: "70%"}},
                span {className: "guide-progress-text"}, "22%"
              div {className: "guide-progress-completed", style: {height: "30%"}}
              div {className: "category-name"}, "Mobility"

            div {className: "guide-progress-lower"},
              ul {},
                li {},
                  span {className: "item-point"}
                  span {className: "item-text"}, "Go Electric"
                li {},
                  span {className: "item-point"}
                  span {className: "item-text"}, "Use Public Transportation"
        li {},
          div {className: "guide-progress-col"},
            div {className: "guide-progress-upper"},
              div {className: "striped", style: {height: "35%"}},
                span {className: "guide-progress-text"}, "8%"
              div {className: "guide-progress-completed", style: {height: "0%"}}
              div {className: "category-name"}, "Mobility"

            div {className: "guide-progress-lower"},
              ul {},
                li {},
                  span {className: "item-point"}
                  span {className: "item-text"}, "Go Electric"
                li {},
                  span {className: "item-point"}
                  span {className: "item-text"}, "Use Public Transportation"
        li {},
          div {className: "guide-progress-col"},
            div {className: "guide-progress-upper"},
              div {className: "striped", style: {height: "20%"}},
                span {className: "guide-progress-text"}, "7%"
              div {className: "guide-progress-completed", style: {height: "7%"}}
              div {className: "category-name"}, "Mobility"

            div {className: "guide-progress-lower"},
              ul {},
                li {},
                  span {className: "item-point"}
                  span {className: "item-text"}, "Go Electric"
                li {},
                  span {className: "item-point"}
                  span {className: "item-text"}, "Use Public Transportation"
