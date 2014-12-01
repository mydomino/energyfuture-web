username = process.env.SENDGRID_USERNAME
password = process.env.SENDGRID_PASSWORD
recipients = process.env.EMAIL_RECIPIENTS
from = process.env.EMAIL_HOST
Sendgrid = require('sendgrid')(username, password)

module.exports = class QuestionnaireEmail
  constructor: ->
    @email = new Sendgrid.Email()
    @email.setFrom(from)
    @email.setSubject('New answer')
    @email.addTo(recipients)
    @email.addHeader('X-Sent-Using', 'SendGrid-API')
    @email.addHeader('X-Transport', 'web')

  send: (answers, callback) ->
    @email.setHtml("<p>#{JSON.stringify(answers)}</p>")
    Sendgrid.send @email, (err, json) ->
      console.log "Error while sending email: #{err}" if err
      callback(error: err, json: json)

