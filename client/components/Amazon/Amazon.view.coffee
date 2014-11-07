{div, p, img, span, h2} = React.DOM

_ = require 'lodash'

# hasValidData = (guide) ->
#   return false unless guide
#   return false if _.isEmpty guide.get('bookIds')
#   true


module.exports = React.createClass
  displayName: 'Amazon'

  getInitialState: ->
    books: []

  getDefaultProps: ->
    bookIds: ['B009UBQVT4', '0307984826', '1607741911']

  componentDidMount: ->
    $.get "/amazon-products", books: @props.bookIds, (res) =>
      @setState books: res if @isMounted()

  render: ->
    return false if _.isEmpty @props.bookIds
    div {className: 'guide-module guide-module-amazon-products'},
      h2 {className: 'guide-module-header'}, 'popular books'
      p {className: "guide-module-subheader"}, "Book reviews from Amazon.com"

      div {className: 'book-list'},
        _.map @state.books, (book) ->
          div {className: 'book-item'},
            img {src: book.imageUrl, className: 'book-image'}
            p {className: "book-author-section"},
              span {}, "by"
              span {className: "book-authors"}, book.authors
