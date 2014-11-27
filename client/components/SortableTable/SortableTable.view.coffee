{div, h2, table, thead, tbody, th, tr, td, img, p} = React.DOM

_ = require 'lodash'
Autolinker = require 'autolinker'

hasValidData = (guide) ->
  return false unless guide
  return false if _.isEmpty guide.get('sortable-table')
  true

module.exports = React.createClass
  displayName: 'SortableTable'

  componentDidMount: ->
    tableObject = $(@refs.tableContent.getDOMNode())
    if tableObject.height() >= 600
      tableObject.css('max-height', 500)
      $(@refs.readMore.getDOMNode()).show()

  sortedHeaders: (headers) ->
    _.sortBy(headers, 'position')

  sortedHeaderTitles: (headers) ->
    _.pluck @sortedHeaders(headers), 'title'

  sortedHeaderKeys: (headers) ->
    _.pluck @sortedHeaders(headers), 'key'

  showMore: (event) ->
    $(@refs.tableContent.getDOMNode()).css('max-height', 'none')
    $(@refs.readMore.getDOMNode()).hide()

  render: ->
    return false unless hasValidData(@props.guide)
    sortableTable = @props.guide.get('sortable-table')
    sortedHeaderTitles = @sortedHeaderTitles(sortableTable.headers)
    sortedHeaderKeys = @sortedHeaderKeys(sortableTable.headers)
    div {className: 'guide-module guide-module-sortable-table'},
      h2 {className: 'guide-module-header'}, sortableTable.heading
      p {className: 'guide-module-subheader', dangerouslySetInnerHTML: {"__html": Autolinker.link(sortableTable.subheading)}}
      div {className: 'guide-module-content'},
        table {ref: 'tableContent'},
          thead {},
            _.map sortedHeaderTitles, (title) ->
              th {}, title
          tbody {},
            _.map sortableTable.content, (row) ->
              tr {},
              _.map sortedHeaderKeys, (key) ->
                td {dangerouslySetInnerHTML: {"__html": row[key]}},
        div {className: 'sortable-table-read-more', ref: 'readMore'},
          div {className: 'read-more-mask'}
          img {className : 'read-more-button', src: '/img/show-more.svg', onClick: @showMore}
