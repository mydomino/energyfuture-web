express = require 'express'
compress = require 'compression'
staticFiles = require 'serve-static'
http = require 'http'
{join} = require 'path'

AmazonProducts = require './server/AmazonProducts'

PORT = Number(process.env.PORT || 8080);

app = express()
app.disable 'x-powered-by'

app.use compress()
app.use staticFiles './public'

app.use (err, req, res, next) ->
  console.error err.stack
  res.send 500, 'Something broke!'

app.get "/amazon-products/:id", (req, res) ->
  new AmazonProducts().itemLookup req.params.id, (data) =>
    res.status(200).send(data)

# page.js - client-side routing
app.get '/*', (req, res) ->
  res.sendFile idxFile, { root: __dirname }

httpServer = http.createServer app
idxFile = './public/index.html'

httpServer.listen PORT, ->
  console.log 'info', "Server running on #{PORT}"
