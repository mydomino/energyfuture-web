{div, p, img, span, h2, a} = React.DOM

_ = require 'lodash'
LoadingIcon = require '../LoadingIcon/LoadingIcon.view'

hasValidData = (guide) ->
  return false unless guide
  return false if _.isEmpty guide.get('bookIds')
  true

module.exports = React.createClass
  displayName: 'Amazon'

  getInitialState: ->
    books: []

  getDefaultProps: ->
    guide: {}

  componentDidMount: ->
    $.get "/amazon-products", books: @props.guide.get('bookIds'), (res) =>
      @setState books: res if @isMounted()

  render: ->
    return false unless hasValidData(@props.guide)
    if _.isEmpty @state.books
      new LoadingIcon
    else
      div {className: 'guide-module guide-module-amazon-products'},
        h2 {className: 'guide-module-header'}, 'popular books'
        p {className: "guide-module-subheader"}, "Book reviews from Amazon.com"

        div {className: 'book-list'},
          _.map @state.books, (book) ->
            div {className: 'book-item'},
              a {href: book.itemLink, target: '_blank'},
                img {src: book.imageUrl, className: 'book-image'}
              p {className: "book-author-section"},
                span {}, "by"
                span {className: "book-authors"}, book.authors
              img {src: book.avgStarRatingImage}
              span {className: 'book-review-count'}, "(#{book.reviewCount} Reviews)"
