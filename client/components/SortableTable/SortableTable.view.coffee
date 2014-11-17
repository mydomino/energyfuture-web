{div, h2, table, thead, tbody, th, tr, td, img} = React.DOM

_ = require 'lodash'

hasValidData = (guide) ->
  return false unless guide
  return false if _.isEmpty guide.get('sortable-table')
  true

module.exports = React.createClass
  displayName: 'SortableTable'


  sortedHeaders: (headers) ->
    _.sortBy(headers, 'position')

  sortedHeaderTitles: (headers) ->
    _.pluck @sortedHeaders(headers), 'title'

  sortedHeaderKeys: (headers) ->
    _.pluck @sortedHeaders(headers), 'key'

  showMore: (event) ->
    $(@refs.tableContent.getDOMNode()).height('100%')
    $(@refs.readMoreSection.getDOMNode()).hide()

  render: ->
    return false unless hasValidData(@props.guide)
    sortableTable = @props.guide.get('sortable-table')
    sortedHeaderTitles = @sortedHeaderTitles(sortableTable.headers)
    sortedHeaderKeys = @sortedHeaderKeys(sortableTable.headers)
    div {className: 'guide-module guide-module-sortable-table'},
      h2 {className: 'guide-module-header'}, 'Financing approaches'

      table {ref: 'tableContent'},
        thead {},
          _.map sortedHeaderTitles, (title) ->
            th {}, title
        tbody {},
          _.map sortableTable.content, (row) ->
            tr {},
            _.map sortedHeaderKeys, (key) ->
              td {}, row[key]
      div {className: 'sortable-table-read-more', ref: 'readMoreSection'},
        div {className: 'read-more-mask'}
        img {className : 'read-more-button', src: '/img/show-more.svg', onClick: @showMore}
