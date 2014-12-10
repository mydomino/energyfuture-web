{div, p, img, span, h2, a} = React.DOM

_ = require 'lodash'
auth = require '../../auth'
MixpanelMixin = require '../../mixins/MixpanelMixin'
LoadingIcon = require '../LoadingIcon/LoadingIcon.view'
Carousel = require '../Carousel/Carousel.view'
Autolinker = require 'autolinker'
LinkParserMixin = require '../../mixins/LinkParserMixin'

hasValidData = (guide) ->
  return false unless guide
  return false if _.isEmpty guide.get('amazon')
  true

module.exports = React.createClass
  displayName: 'Amazon'
  mixins: [MixpanelMixin]

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

  componentDidMount: ->
    $.get("/amazon-products", products: @productIds())
    .done((res) =>
      @setState products: res if @isMounted())
    .fail((res) =>
        console.error(res)
        @setState dataError: true if @isMounted())

  onClickTrackingLink: ->
    console.log "Track this link."

  trackingLinksContainer: ->
    @refs['amazon-products-container'].getDOMNode()

  productItems: ->
    _.map @state.products, (product) =>
      cat = @productImportanceCategory(product.id)
      div {className: 'product-item', key: "product-item-#{product.id}"},
        a {href: product.itemLink, className: "product-link mixpanel-affiliate-link", target: '_blank', onClick: @trackAffiliateAction},
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

    if _.isEmpty @state.products
      new LoadingIcon
    else
      div {className: 'guide-module guide-module-amazon-products', ref: 'amazon-products-container'},
        h2 {className: 'guide-module-header'}, amazon.heading
        p {className: "guide-module-subheader", dangerouslySetInnerHTML: {"__html": Autolinker.link(amazon.subheading)}}

        div {className: 'guide-module-content'},
          div {className: 'product-list'},
            if @state.products.length > 3
              new Carousel count: 3, items: @productItems()
            else
              @productItems()
