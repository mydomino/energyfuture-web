{div, h2, p, span, a, hr} = React.DOM

positionSidebar = (element) ->
  anchor = element.parentElement
  if window.scrollY + element.offsetHeight > anchor.offsetTop + anchor.offsetHeight - 40
    element.style.position = null
    element.style.top = (anchor.offsetHeight - element.offsetHeight) + 'px'
    element.style.left = null
  else if window.scrollY > anchor.offsetTop
    element.style.position = 'fixed'
    element.style.top = '40px'
    element.style.left = (anchor.offsetLeft - 100) + 'px'
  else
    element.style.position = null
    element.style.top = null
    element.style.left = null

  return

module.exports = React.createClass
  displayName: 'ImpactSidebar'
  componentDidMount: ->
    sidebar = @refs.sidebar.getDOMNode()
    # positionSidebar(sidebar)

    window?.onscroll = (e) ->
      positionSidebar(sidebar)

    window?.onresize = (e) ->
      positionSidebar(sidebar)
  getDefaultProps: ->
    category: ''
    percent: 0
  render: ->
    div {className: "impact-sidebar", ref: 'sidebar'},
      div {className: "impact-sidebar-graph"},
        div {className: "progress"},
          div {className: "progress-bar progress-bar-before", style: { height: @props.percent + '%' }},
            span {className: "progress-bar-label"}, "Before"
          div {className: "progress-bar progress-bar-after", style: { height: (100 - @props.percent) + '%' }},
            span {className: "progress-bar-label"}, "After"
        p {}, @props.category
      hr {}
      div {},
        p {}, "Taking this action will bring you #{@props.percent}% closer to safe carbon levels."
      hr {}
      div {},
        a {className: 'footprint-icon', href: '/footprint' }, "See Your Impact"
