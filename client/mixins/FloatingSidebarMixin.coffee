positionSidebar = (element, leftOffset) ->
  anchor = element.parentElement
  style = { position: null, top: null, left: null }

  if !leftOffset
    leftOffset = (anchor) ->
      anchor.offsetLeft - 150

  if window.scrollY + element.offsetHeight > anchor.offsetTop + anchor.offsetHeight - 40
    style.top = (anchor.offsetHeight - element.offsetHeight) + 'px'
  else if window.scrollY > anchor.offsetTop
    style.position = 'fixed'
    style.top = '40px'
    style.left = leftOffset(anchor, element) + 'px'

  for property, value of style
    element.style[property] = value

  return

module.exports =
  onScrollEventHandler: ->
    if @refs.sidebar
      positionSidebar(@refs.sidebar.getDOMNode(), @calculateLeftOffset)

  setupSidebarPositioning: ->
    window.addEventListener('scroll', @onScrollEventHandler, false);
    window.addEventListener('resize', @onScrollEventHandler, false);

  removeSidebarPositioning: ->
    window.removeEventListener('scroll', @onScrollEventHandler, false);
    window.removeEventListener('resize', @onScrollEventHandler, false);

  componentWillUnmount: ->
    @removeSidebarPositioning()

  componentDidMount: ->
    @setupSidebarPositioning()
