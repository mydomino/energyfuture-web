module.exports = (ctx, next) ->
  console.log 'Authentication Goes Here', ctx.querystring
  if ctx.path == '/protected'
    setTimeout (() -> page.replace('/')), 0
  else
    next();
