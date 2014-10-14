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
        li {}, "50%",
          div {className: "striped"}
          div {className: "solid"}
        li {}, "50%",
          div {className: "striped"}
          div {className: "solid"}
        li {}, "50%",
          div {className: "striped"}
          div {className: "solid"}
        li {}, "50%",
          div {className: "striped"}
          div {className: "solid"}
        li {}, "50%",
          div {className: "striped"}
          div {className: "solid"}

