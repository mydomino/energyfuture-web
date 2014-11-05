auth = require '../auth'

module.exports = (ctx, next) ->
  ctx.user = auth.user if auth.user
  next();
