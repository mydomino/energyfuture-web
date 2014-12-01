{span, i} = React.DOM

Number::numberFormat = (decimals, dec_point, thousands_sep) ->
  dec_point = (if typeof dec_point isnt "undefined" then dec_point else ".")
  thousands_sep = (if typeof thousands_sep isnt "undefined" then thousands_sep else ",")
  parts = @toFixed(decimals).split(".")
  parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, thousands_sep)
  parts.join dec_point

formatScore = (score) ->
  num = parseInt(score, 10)
  return 0 unless num > 0
  num.numberFormat()

module.exports = React.createClass
  displayName: 'ImpactScore'
  getDefaultProps: ->
    score: 0
    color: 'inherit'

  propTypes:
    score: React.PropTypes.number.isRequired
    color: React.PropTypes.string

  render: ->
    style =
      color: @props.color

    span {className: 'impact-score', style: style},
      i {className: 'pu-icon-impact'}
      formatScore(@props.score)
