{div, p, a, span, br, footer, img} = React.DOM

module.exports = React.createClass
  displayName: 'Footer'
  goToContactPage: (e) ->
    # We're forcing a page reload here because the contact
    # page has a widget that won't load if it's already been
    # loaded once. This is a hack until we find a workaround.
    e.preventDefault()
    document.location = '/contact'

  goToAboutPage: (e) ->
    e.preventDefault()
    page('/about')

  render: ->
      footer {className: 'footer'},
        div {className: 'col col1'},
          p {},
            "© 2017 MyDomino Inc."
            br {}
            a {href: 'https://www.mydomino.com/terms'}, 'Terms of Service'
            "  |  "
            a {href: 'https://www.mydomino.com/privacy'}, 'Privacy Policy'
            "  |  CA CSLB 1016806"
        div {className: 'col col2'}
        div {className: 'col col3'},
          img {src: '/img/mydomino_logo_footer.svg', width: "250px"}
