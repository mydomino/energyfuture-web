{div, p, img, span, h2, h3, a, ul, li} = React.DOM

_ = require 'lodash'
LoadingIcon = require '../LoadingIcon/LoadingIcon.view'

hasValidData = (guide) ->
  return false unless guide
  return false if _.isEmpty guide.get('yelp')
  true

module.exports = React.createClass
  displayName: 'Yelp'

  getInitialState: ->
    data: []

  getDefaultProps: ->
    guide: {}

  componentDidMount: ->
    $.get "/yelp-listings", term: @props.guide.get('yelp').searchTerms[0], location: "San Fransisco", (res) =>
      @setState data: res if @isMounted()

  render: ->
    return false unless hasValidData(@props.guide)
    yelp = @props.guide.get('yelp')

    if _.isEmpty @state.data
      new LoadingIcon
    else
      div {className: "guide-module guide-module-yelp"},
        h2 {className: "guide-module-header"}, yelp.heading
        p {className: "guide-module-subheader"}, "Powered by Yelp.com"

        div {className: 'guide-module-content'},
          ul {className: 'yelp-list'},
            _.map _.first(@state.data.businesses, 7), (i) =>
              console.log(i)
              li {},
                div {className: "yelp-main"},
                  div {className: "yelp-media-block"},
                    div {className: "yelp-media-avatar"},
                      div {className: "yelp-media-photobox"},
                        a {href: i.url},
                          img {src: i.image_url}

                    div {className: "yelp-media-story"},
                      h3 {}, i.name
                      div {className: "yelp-media-ratingsbox"},
                        div {className: "yelp-media-rating"},
                          img {alt:"#{i.rating} star rating", class:"offscreen", src: i.rating_img_url}
                        span {className: "yelp-media-review-count"}, "#{i.review_count} reviews"

                    div {className: "clear-both"}

            console.log(@state.data)

