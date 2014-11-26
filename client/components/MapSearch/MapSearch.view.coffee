{div, h2} = React.DOM
_ = require 'lodash'
locationSearch = require '../../vendor/location-search'

_locationCache = null
_searchResultsCache = {}

hasValidData = (guide) ->
  return false unless guide
  return false if _.isEmpty guide.get('mapSearchTerm')
  true

module.exports = React.createClass
  displayName: 'MapSearch'

  getDefaultProps: ->
    guide: null

  handleMarkers: (markers) ->
    self = @
    markers.map (result) ->
      marker = new L.Marker(new L.LatLng(result.Latitude, result.Longitude));
      marker.on 'click', (e) ->
        self.handleMarkerClick(result)
      self.mapObj.addLayer(marker);

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

  handleFailedLocation: (e) ->
    console.log "Position could not be found"
    return

  componentDidMount: ->
    @mapObj = L.mapbox.map(@refs.map.getDOMNode(), 'illanti.in9ig8o9', { zoomControl: false });

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

  handleMarkerClick: (marker) ->
    console.log(marker)
    @props.markerClickHandler(marker) if @props.markerClickHandler

  componentWillUpdate: ->
    @mapObj.invalidateSize()

  render: ->
    return false unless hasValidData @props.guide

    div {className: 'guide-module'},
      h2 {className: 'guide-module-header'}, 'Map'
      div {className: 'guide-module-content'},
        div {className: 'map', ref: 'map', onClick: @handleMapClick}
