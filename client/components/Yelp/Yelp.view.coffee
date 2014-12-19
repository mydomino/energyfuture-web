{div, p, img, span, h2, h3, a, ul, li} = React.DOM

_ = require 'lodash'
auth = require '../../auth'
LoadingIcon = require '../LoadingIcon/LoadingIcon.view'
Mixpanel = require '../../models/Mixpanel'
BindAffiliateLinkMixin = require '../../mixins/BindAffiliateLinkMixin'

hasValidData = (guide) ->
  return false unless guide
  return false if _.isEmpty guide.get('yelp')
  true

module.exports = React.createClass
  displayName: 'Yelp'
  mixins: [BindAffiliateLinkMixin]

  getInitialState: ->
    data: []
    dataError: false

  getDefaultProps: ->
    guide: {}

  componentDidMount: ->
    y = @props.guide.get('yelp')
    query =
      term: y.searchTerms[0]
      location: "San Fransisco"
      limit: y.limit

    $.get("/yelp-listings", query)
    .done((res) =>
      @setState data: res if @isMounted())
    .fail((res) =>
      console.error(res)
      @setState dataError: true if @isMounted())

  addressText: (l) ->
    {
      "line1": l.address.join(" ")
      "line2": "#{l.city}, #{l.state_code} #{l.postal_code}"
    }

  parseRestaurantInfo: (url) ->
    r = url.match /biz\/(.*)/
    r[1] unless _.isEmpty r

  trackAffiliateLinkAction: (event) ->
    Mixpanel.emit 'analytics.affiliate.click',
      affiliate: 'yelp'
      guide_id: @props.guide.id
      distinct_id: auth.user?.id
      restaurant: @parseRestaurantInfo(event.currentTarget.href)

  render: ->
    return false unless hasValidData(@props.guide)
    yelp = @props.guide.get('yelp')

    if _.isEmpty @state.data
      new LoadingIcon
    else
      div {className: "guide-module guide-module-yelp"},
        h2 {className: "guide-module-header"}, yelp.heading
        p {className: "guide-module-subheader", dangerouslySetInnerHTML: {"__html": "Powered by <a href='yelp.com'>Yelp</a>"}}

        div {className: 'guide-module-content'},
          ul {className: 'yelp-list'},
            _.map @state.data['businesses'], (i) =>
              li {key: "yelp-item-#{i.id}", className: "yelp-main"},
                div {className: "yelp-media-block"},
                  div {className: "yelp-media-avatar"},
                    div {className: "yelp-media-photobox"},
                      a {href: i.url, target: "_blank", className: 'mixpanel-affiliate-link'},
                        img {src: i.image_url}

                  div {className: "yelp-media-story"},
                    a {href: i.url, target: "_blank", className: 'mixpanel-affiliate-link'},
                      h3 {}, i.name
                    div {className: "yelp-media-ratingsbox"},
                      div {className: "yelp-media-rating"},
                        img {alt:"#{i.rating} star rating", className:"offscreen", src: i.rating_img_url}
                      span {className: "yelp-media-review-count"}, "#{i.review_count} reviews"

                  div {className: "yelp-address-block"},
                    p {className: "yelp-address-line"},
                      @addressText(i.location)["line1"]
                    p {className: "yelp-address-line"},
                      @addressText(i.location)["line2"]
                    p {className: "yelp-address-line"},
                        i.display_phone

                  div {className: "yelp-review-snippet-container"},
                    div {className: "yelp-review-snippet"},
                      a {href: i.url, target: '_blank', className: 'mixpanel-affiliate-link'},
                        img {src: i.snippet_image_url}
                      div {className: "yelp-review-snippet-story"},
                        p {}, i.snippet_text
