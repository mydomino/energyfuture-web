{div} = React.DOM

module.exports = React.createClass
  displayName: 'LoadingIcon'
  timer: 0
  count: 0

  getInitialState: ->
    dots: '...'

  componentDidMount: ->
    @timer = setInterval =>
      @count = if @count > 3 then 1 else @count + 1
      @setState dots: new Array( @count + 1 ).join('.')
    , 200

  componentWillUnmount: ->
    clearInterval @timer

  render: ->
    div {className: 'loading-icon'}, 'Loading' + @state.dots
