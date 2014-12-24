module.exports =
  hideModule: (name) ->
    $(@refs[name].getDOMNode()).hide()
    false
