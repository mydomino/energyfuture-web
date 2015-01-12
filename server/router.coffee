_ = require 'lodash'

express = require 'express'
compress = require 'compression'
staticFiles = require 'serve-static'
http = require 'http'
bodyParser = require('body-parser')
json2csv = require 'nice-json2csv'
domain = require 'domain'

React = require 'react/addons'
ReactAsync = require 'react-async'

{join} = require 'path'

AmazonProducts = require './models/AmazonProducts'
QuestionnaireEmail = require './models/QuestionnaireEmail'
YelpListings = require './models/YelpListings'
Appointments = require './models/Appointments'
Signups = require './models/Signups'

Routes = require './routes'

PORT = Number(process.env.PORT || 8080);

app = express()
app.disable 'x-powered-by'

app.use compress()
app.use staticFiles './public'
app.use bodyParser.json()
app.use json2csv.expressDecorator

app.set('view engine', 'jade')

showErrorPage = (res) ->
  res.status(500)
  res.sendFile './500.html', { root: __dirname }

app.use (req, res, next) ->
  d = domain.create()
  d.on 'error', (e) ->
    console.error e.stack
    showErrorPage(res)

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
    params = [url]
    params.id = req.params.id
    props =
      params: params
      context:
        pathname: url
      user: undefined

    ReactAsync.renderToStringAsync ReactComponent(props), (err, markup, data) ->
      if err
        console.log(err)
        return showErrorPage(res)

      res.render 'index', {content: ReactAsync.injectIntoMarkup(markup, data), data}, (e, h) ->
        res.status(200).send(h) unless e

for page in Routes.pages
  renderReactComponent(page)

app.get "/app.js", (req, res) ->
  res.status(200)
  res.sendFile './public/app.js', { root: __dirname }

httpServer = http.createServer app

httpServer.listen PORT, ->
  console.log 'info', "Server running on #{PORT}"
