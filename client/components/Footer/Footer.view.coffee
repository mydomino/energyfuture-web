React = require 'react'
{div, p, a, span, br, footer} = React.DOM

Footer = React.createClass
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
            "You support our work by buying products and services"
            br {}
            "recommended on this site. Read our "
            a {className: "mixpanel-internal-link", href: "/terms"}, "Terms of Service"
            br {}
            " and "
            a {className: "mixpanel-internal-link", href: "/privacy"}, "Privacy Policy"
            " for more."
        div {className: 'col col2'},
          div {className: 'footer-logo'}
        div {className: 'col col3'},
          p {},
            span {className: 'footer-logo'}
            a {className: 'mixpanel-internal-link', onClick: @goToAboutPage}, 'Learn about us'
            ' or '
            a {className: 'mixpanel-internal-link', onClick: @goToContactPage}, 'get in touch'

module.exports = React.createFactory Footer
