{div, h2, table, thead, tbody, th, tr, td, img, p, i} = React.DOM

'/* @ifdef AWS_ASSOCIATE_TAG */'
awsAssociateTag = '/* @echo AWS_ASSOCIATE_TAG */'
'/* @endif */'
awsAssociateTag = awsAssociateTag || 'dummyTag'

_ = require 'lodash'
Autolinker = require 'autolinker'

module.exports = React.createClass
  displayName: 'SortableTable'

  getInitialState: ->
    collapsible: false
    collapsed: true

  componentDidMount: ->
    tableObject = $(@refs.tableContent.getDOMNode())
    if tableObject.height() >= 600
      @setState collapsible: true

  sortedHeaders: (headers) ->
    _.sortBy(headers, 'position')

  sortedHeaderTitles: (headers) ->
    _.pluck @sortedHeaders(headers), 'title'

  sortedHeaderKeys: (headers) ->
    _.pluck @sortedHeaders(headers), 'key'

  toggleExpandCollapse: ->
    unless @state.collapsed
      tablePosition = $(@refs.tableContent.getDOMNode()).offset()
      scrollTo(tablePosition.left, tablePosition.top)
    @setState collapsed: !@state.collapsed

  replaceAmazonPlaceholders: (htmlStr) ->
    htmlStr
      .replace('%AMAZON_BUY_BUTTON%', '/img/amazon-buy-button.gif')
      .replace('%AWS_ASSOCIATE_TAG%', awsAssociateTag)

  render: ->
    sortableTable = @props.content
    return false if _.isEmpty sortableTable
    if @state.collapsible && @state.collapsed
     tableStyle = { maxHeight: 500 }
    else
     tableStyle = {}

    sortedHeaderTitles = @sortedHeaderTitles(sortableTable.headers)
    sortedHeaderKeys = @sortedHeaderKeys(sortableTable.headers)
    div {className: 'guide-module guide-module-sortable-table'},
      h2 {className: 'guide-module-header'}, sortableTable.heading
      p {className: 'guide-module-subheader', dangerouslySetInnerHTML: {"__html": Autolinker.link(sortableTable.subheading)}}
      div {className: 'guide-module-content'},
        table {style: tableStyle, ref: 'tableContent'},
          thead {},
            _.map sortedHeaderTitles, (title, i) ->
              th {key: "sorted-header-titles-#{i}"}, title
          tbody {},
            _.map sortableTable.content, (row, i) =>
              tr {key: "sorted-content-#{i}"},
              _.map sortedHeaderKeys, (key, i) =>
                td {key: "sorted-header-keys-#{i}", dangerouslySetInnerHTML: {"__html": @replaceAmazonPlaceholders(row[key])}}

        if @state.collapsible
          if @state.collapsed
            collapsedClass = ''
            collapsedIcon = 'plus'
          else
            collapsedClass = 'expanded'
            collapsedIcon = 'minus'
          div {className: "sortable-table-expand-collapse #{collapsedClass}", ref: 'expandCollapse'},
            div {className: 'expand-collapse-mask'}
            div {className: "expand-collapse-button"},
              i {className: "icon pu pu-icon-#{collapsedIcon}", onClick: @toggleExpandCollapse}
