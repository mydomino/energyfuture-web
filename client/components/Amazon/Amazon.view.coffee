{div, p, img, span, h2, a} = React.DOM

_ = require 'lodash'
auth = require '../../auth'
LoadingIcon = require '../LoadingIcon/LoadingIcon.view'
Carousel = require '../Carousel/Carousel.view'
Autolinker = require 'autolinker'
Mixpanel = require '../../models/Mixpanel'
BindAffiliateLinkMixin = require '../../mixins/BindAffiliateLinkMixin'

hasValidData = (guide) ->
  return false unless guide
  return false if _.isEmpty guide.get('amazon')
  true

module.exports = React.createClass
  displayName: 'Amazon'
  mixins: [BindAffiliateLinkMixin]

  getInitialState: ->
    products: []
    dataError: false

  getDefaultProps: ->
    guide: {}

  products: ->
    @props.guide.get('amazon').productIds

  productIds: ->
    _.pluck(_.sortBy(@products(), 'position'), 'id')

  productImportanceCategory: (id) ->
    _.find(@products(), 'id': id).category

  parseProductName: (url) ->
    r = url.match(/amazon\.com\/(.*)\/dp|gp/)
    r[1] unless _.isEmpty r

  componentDidMount: ->
    $.get "/amazon-products",
      products: @productIds()
    .done (res) =>
      @setState products: res if @isMounted()
    .fail (res) =>
      console.error(res)
      @setState dataError: true if @isMounted()

  trackAffiliateLinkAction: (event) ->
    Mixpanel.emit 'analytics.affiliate.click',
      affiliate: 'amazon'
      guide_id: @props.guide.id
      distinct_id: auth.user?.id
      product: @parseProductName(event.currentTarget.href)

  productItems: ->
    _.map @state.products, (product) =>
      cat = @productImportanceCategory(product.id)
      div {className: 'product-item', key: "product-item-#{product.id}"},
        a {href: unescape(product.itemLink), className: "product-link mixpanel-affiliate-link", target: '_blank'},
          img {src: product.imageUrl, className: 'product-image'}
          p {className: "product-creator-section"},
            span {}, "by"
            span {className: "product-creators"}, product.creators
        a {href: product.reviewsLink, className: "review-link", target: '_blank'},
          img {src: product.avgStarRatingImage}
          span {className: 'product-review-count'}, "(#{product.reviewCount} Reviews)"
        div {className: "product-importance-category #{cat}"}, cat

  render: ->
    return false unless hasValidData(@props.guide)
    return false if @state.dataError
    amazon = @props.guide.get('amazon')

    div {className: 'guide-module guide-module-amazon-products'},
      h2 {className: 'guide-module-header'}, amazon.heading
      p {className: "guide-module-subheader", dangerouslySetInnerHTML: {"__html": Autolinker.link(amazon.subheading)}}

      if _.isEmpty @state.products
        new LoadingIcon
      else
        div {className: 'guide-module-content'},
          div {className: 'product-list'},
            if @state.products.length > 3
              new Carousel count: 3, items: @productItems()
            else
              @productItems()
