express = require 'express'
compress = require 'compression'
staticFiles = require 'serve-static'
http = require 'http'
bodyParser = require('body-parser')
json2csv = require 'nice-json2csv'
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

app.use (err, req, res, next) ->
  console.error err.stack
  res.send 500, 'Something broke!'

app.get "/amazon-products", (req, res) ->
  new AmazonProducts().itemLookup(req.query.products,
    ((data) => res.status(200).send(data)),
    ((errr) => res.status(502).send("Server error on trying to fetch data from Amazon. #{errr}")))

app.get "/yelp-listings", (req, res) ->
  new YelpListings().search req.query, (data) =>
    if data.hasOwnProperty('error')
      res.status(502).send("Server error on trying to fetch data from Yelp.")
    else
      res.status(200).send(data)

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

# page.js - client-side routing
app.get '/*', (req, res) ->
  res.sendFile idxFile, { root: __dirname }

httpServer = http.createServer app
idxFile = './public/index.html'

httpServer.listen PORT, ->
  console.log 'info', "Server running on #{PORT}"
