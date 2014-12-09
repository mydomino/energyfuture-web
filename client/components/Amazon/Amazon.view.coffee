{div, p, img, span, h2, a} = React.DOM

_ = require 'lodash'
LoadingIcon = require '../LoadingIcon/LoadingIcon.view'
Carousel = require '../Carousel/Carousel.view'

hasValidData = (guide) ->
  return false unless guide
  return false if _.isEmpty guide.get('amazon')
  true

module.exports = React.createClass
  displayName: 'Amazon'

  getInitialState: ->
    products: []

  getDefaultProps: ->
    guide: {}

  componentDidMount: ->
    $.get "/amazon-products", products: @props.guide.get('amazon').productIds, (res) =>
      @setState products: res if @isMounted()

  productItems: ->
    _.map @state.products, (product) ->
      div {className: 'product-item'},
        a {href: product.itemLink, className: "product-link affiliate-link", target: '_blank'},
          img {src: product.imageUrl, className: 'product-image'}
          p {className: "product-creator-section"},
            span {}, "by"
            span {className: "product-creators"}, product.creators
        img {src: product.avgStarRatingImage}
        span {className: 'product-review-count'}, "(#{product.reviewCount} Reviews)"

  render: ->
    return false unless hasValidData(@props.guide)
    amazon = @props.guide.get('amazon')
    if _.isEmpty @state.products
      new LoadingIcon
    else
      div {className: 'guide-module guide-module-amazon-products'},
        h2 {className: 'guide-module-header'}, amazon.heading
        p {className: "guide-module-subheader"}, amazon.subheading

        div {className: 'guide-module-content'},
          div {className: 'product-list'},
            if @state.products.length > 3
              new Carousel count: 3, items: @productItems()
            else
              @productItems()
