express = require 'express'
compress = require 'compression'
staticFiles = require 'serve-static'
http = require 'http'
bodyParser = require('body-parser')
json2csv = require 'nice-json2csv'
domain = require 'domain'

React = require 'react/addons'

{join} = require 'path'

AmazonProducts = require './server/AmazonProducts'
QuestionnaireEmail = require './server/QuestionnaireEmail'
YelpListings = require './server/YelpListings'
Appointments = require './server/Appointments'
Signups = require './server/Signups'

Routes = require './client/server-routes'

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

renderReactComponent = (page) ->
  url = page[0]
  ReactComponent = page[1]

  app.get url, (req, res) ->
    props =
      context:
        pathname: url
      params:
        [url, id: req.params.id]
    content = React.renderToString(React.createFactory(ReactComponent)(props))
    console.log(content)
    res.render('index', {content: content})

for page in Routes.pages
  renderReactComponent(page)

app.get "/app.js", (req, res) ->
  res.status(200)
  res.sendFile './public/app.js', { root: __dirname }

httpServer = http.createServer app

httpServer.listen PORT, ->
  console.log 'info', "Server running on #{PORT}"
