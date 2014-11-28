{div, h2} = React.DOM
_ = require 'lodash'
locationSearch = require '../../vendor/location-search'

_locationCache = null
_searchResultsCache = {}

hasValidData = (guide) ->
  return false unless guide
  return false if _.isEmpty guide.get('mapSearchTerm')
  true

$.fn.ratingStars = ->
  $(@).html $("<span/>").width($(@).text() * 16)

module.exports = React.createClass
  displayName: 'MapSearch'

  getDefaultProps: ->
    guide: null

  handleMarkers: (markers) ->
    markers.map (result) =>
      marker = new L.Marker(new L.LatLng(result.Latitude, result.Longitude))

      markerClickCallbacks = []
      markerClickCallbacks.push(@handleTooltip(marker, result))

      marker.on 'click', =>
        @handleMarkerClick(result, markerClickCallbacks)

      @mapObj.addLayer(marker)

  handleTooltip: (marker, result) ->
    name = result.Title
    address = result.Address
    phone = result.Phone

    link = if result.BusinessClickUrl
      "<a href='" + result.BusinessClickUrl + "' target='_blank'>#{result.BusinessClickUrl}</a>"
    else
      ""

    averageRating = Number(result.Rating.AverageRating)
    ratingStars = unless isNaN(averageRating)
      "<span class='map-search-tooltip-average-rating'>" + averageRating + "</span>"
    else
      ""

    popupContent = "<div class='map-search-tooltip'><ul><li>#{name}</li><li>#{address}</li><li>#{phone}</li><li>#{link}</li><li>#{ratingStars}</li></ul></div>"
    marker.bindPopup(popupContent, closeButton: true, minWidth: 200)

    -> $('.map-search-tooltip-average-rating').ratingStars()

  handleLocation: (loc) ->
    locationSearchTerm = @props.guide.get('mapSearchTerm')

    featureLayer = L.mapbox.featureLayer().addTo(@mapObj);

    @mapObj.fitBounds loc.bounds, { maxZoom: 13 }

    featureLayer.setGeoJSON
      type: "Feature"
      geometry:
        type: "Point"
        coordinates: [
          loc.latlng.lng
          loc.latlng.lat
        ]

      properties:
        title: "Your Location"
        "marker-color": "#ff8888"
        "marker-symbol": "star"

    if locationSearchTerm
      if _searchResultsCache.hasOwnProperty locationSearchTerm
        @handleMarkers _searchResultsCache[locationSearchTerm]
      else
        locationSearch.search loc.latlng.lat, loc.latlng.lng, locationSearchTerm, (results) =>
          _searchResultsCache[locationSearchTerm] = results
          @handleMarkers(results)

    featureLayer.on "layeradd", (e) ->
      marker = e.layer
      feature = marker.feature

      popupContent = "<a target=\"_blank\" class=\"popup\" href=\"" + feature.properties.url + "\">" + "<img src=\"" + feature.properties.image + "\" />" + feature.properties.city + "</a>"

      marker.bindPopup popupContent,
        closeButton: false
        minWidth: 320

  handleFailedLocation: (e) ->
    console.log "Position could not be found"

  componentDidMount: ->
    @mapObj = L.mapbox.map(@refs.map.getDOMNode(), 'illanti.in9ig8o9', { zoomControl: false });
    @toolTipLayer = L.mapbox.featureLayer().addTo(@mapObj)

    if _locationCache?
      @handleLocation(_locationCache)
    else
      @mapObj.on "locationfound", (e) =>
        _locationCache = e
        @handleLocation(e)

      # If the user chooses not to allow their location
      # to be shared, display an error message.
      @mapObj.on "locationerror", @handleFailedLocation

      @mapObj.locate()

  handleMapClick: ->
    @props.mapClickHandler(@) if @props.mapClickHandler

  handleMarkerClick: (marker, callbacks) ->
    @props.markerClickHandler(marker) if @props.markerClickHandler
    callbacks.map (c) -> c()

  componentWillUpdate: ->
    @mapObj.invalidateSize()

  render: ->
    return false unless hasValidData @props.guide

    div {className: 'guide-module'},
      h2 {className: 'guide-module-header'}, 'Map'
      div {className: 'guide-module-content'},
        div {className: 'map', ref: 'map', onClick: @handleMapClick}