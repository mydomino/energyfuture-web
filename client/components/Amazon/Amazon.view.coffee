{div, p, img, span, h2} = React.DOM

_ = require 'lodash'

# hasValidData = (guide) ->
#   return false unless guide
#   return false if _.isEmpty guide.get('bookIds')
#   true


module.exports = React.createClass
  displayName: 'Amazon'

  getInitialState: ->
    book: {}

  getDefaultProps: ->
    bookIds: ['B00540PAUQ']

  componentDidMount: ->
    $.get "/amazon-products", books: @props.bookIds, (res) =>
      @setState book: res if @isMounted()
      console.log res

  render: ->
    return false if _.isEmpty @props.bookIds
    div {className: 'guide-module guide-module-amazon-products'},
      h2 {className: 'guide-module-header'}, 'popular books'
      p {className: "guide-module-subheader"}, "Book reviews from Amazon.com"

      div {className: 'book-list'},
        div {className: 'book-item'},
          img {src: @state.book.imageUrl, className: 'book-image'}
          p {},
            span {}, "by"
            span {}, @state.book.authors
