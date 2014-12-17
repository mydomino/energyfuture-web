{div, p, a, span, br} = React.DOM

module.exports = React.createClass
  displayName: 'Footer'
  render: ->
      div {className: 'footer'},
        div {className: 'col col1'},
          p {},
            "Domino's mission is to reduce the world's carbon"
            br {}
            "emissions by 20% before 2020."
        div {className: 'col col2'},
          div {className: 'footer-logo'}
        div {className: 'col col3'},
          p {},
            span {className: 'footer-logo'}
            a {href: '/about'}, 'Learn More'
            ' or '
            a {}, 'Contact Us'
