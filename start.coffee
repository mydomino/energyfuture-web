express = require 'express'
compress = require 'compression'
staticFiles = require 'serve-static'
http = require 'http'
bodyParser = require('body-parser')
json2csv = require 'nice-json2csv'
domain = require 'domain'

browserify = require 'browserify'
React = require 'react/addons'

{join} = require 'path'

AmazonProducts = require './server/AmazonProducts'
QuestionnaireEmail = require './server/QuestionnaireEmail'
YelpListings = require './server/YelpListings'
Appointments = require './server/Appointments'
Signups = require './server/Signups'

PORT = Number(process.env.PORT || 8080);

app = express()
app.disable 'x-powered-by'

app.use compress()
app.use staticFiles './public'
app.use bodyParser.json()
app.use json2csv.expressDecorator

app.set('view engine', 'jade')

app.use (req, res, next) ->
  d = domain.create()
  d.on 'error', (e) ->
    console.error e.stack
    res.status(500)
    res.sendFile './public/500.html', { root: __dirname }

  d.run(next)

app.get "/amazon-products", (req, res) ->
  new AmazonProducts().itemLookup(req.query.products,
    ((data) => res.status(200).send(data)),
    ((errr) => res.status(502).send("Server error on trying to fetch data from Amazon. #{errr}")))

app.get "/yelp-listings", (req, res) ->
  new YelpListings().search(req.query,
    ((data) => res.status(200).send(data)),
    ((errr) => res.status(502).send("Server error on trying to fetch data from Yelp. #{errr}")))

app.post "/questionnaire-email", (req, res) ->
  new QuestionnaireEmail().send req.body.answers, (data) =>
    if data.error
      res.status(502).send("Server errored out while trying to send email.")
    else
      res.status(201).send(data.json)

app.get "/appointments.csv", (req, res) ->
  Appointments (statusCode, data) ->
    res.status(statusCode).csv(data, "appointments.csv")

app.get "/signups.csv", (req, res) ->
  Signups (statusCode, data) ->
    res.status(statusCode).csv(data, "signups.csv")

Guides = require('./client/pages/Guides/Guides.view')
app.get "/guides", (req, res) ->
  h = React.renderComponentToString(new Guides({context: {pathname: '/'}}))
  res.render('index', {html: h})
  
app.get '/guides/:id', (req, res) ->
  console.log("This page hasn't been hooked up yet")
  res.status(500)
  res.sendFile './public/500.html', { root: __dirname }

app.get "/app.js", (req, res) ->
  res.status(200)
  res.sendFile './public/app.js', { root: __dirname }

httpServer = http.createServer app
idxFile = './public/index.html'

httpServer.listen PORT, ->
  console.log 'info', "Server running on #{PORT}"
