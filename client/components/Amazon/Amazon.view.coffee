{div, p, img, span, h2, a} = React.DOM

_ = require 'lodash'
LoadingIcon = require '../LoadingIcon/LoadingIcon.view'
Carousel = require '../Carousel/Carousel.view'
Autolinker = require 'autolinker'

module.exports = React.createClass
  displayName: 'Amazon'

  getInitialState: ->
    products: []
    dataError: false

  getDefaultProps: ->
    guide: {}

  products: ->
    @props.content.productIds

  productIds: ->
    _.pluck(_.sortBy(@products(), 'position'), 'id')

  productImportanceCategory: (id) ->
    _.find(@products(), 'id': id).category

  componentDidMount: ->
    $.ajax(type: 'GET', url: "/amazon-products", data: { products: @productIds() }, timeout: 15000)
    .done((res) =>
      @setState products: res if @isMounted())
    .fail((res) =>
        console.error(res)
        @setState dataError: true if @isMounted())

  productItems: ->
    _.map @state.products, (product) =>
      cat = @productImportanceCategory(product.id)
      div {className: 'product-item', key: "product-item-#{product.id}"},
        a {href: product.itemLink, className: "product-link", target: '_blank'},
          span {className: 'product-image-wrapper'},
            img {src: product.imageUrl, className: 'product-image'}
          p {className: "product-creator-section"},
            span {}, "by"
            span {className: "product-creators"}, product.creators
        a {href: product.reviewsLink, className: "review-link", target: '_blank'},
          img {src: product.avgStarRatingImage}
          span {className: 'product-review-count'}, "(#{product.reviewCount} Reviews)"
        div {className: "product-importance-category #{cat}"}, cat

  render: ->
    return @props.onError() if @state.dataError
    amazon = @props.content
    return false if _.isEmpty amazon

    if _.isEmpty @state.products
      new LoadingIcon
    else
      div {className: 'guide-module guide-module-amazon-products'},
        h2 {className: 'guide-module-header'}, amazon.heading if amazon.heading?
        p {className: "guide-module-subheader", dangerouslySetInnerHTML: {"__html": Autolinker.link(amazon.subheading)}} if amazon.subheading?

        div {className: 'guide-module-content'},
          div {className: 'product-list'},
            if @state.products.length > 3
              new Carousel count: 3, items: @productItems()
            else
              @productItems()
