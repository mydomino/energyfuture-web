username = process.env.SENDGRID_USERNAME
password = process.env.SENDGRID_PASSWORD
recipients = process.env.EMAIL_RECIPIENTS
from = process.env.EMAIL_HOST
Sendgrid = require('sendgrid')(username, password)

jsonToText = (json) ->
  text = ["<p>A new questionnaire response has been submitted</p>"]
  for key, value of json
    if ['guide_id', 'user_id'].indexOf(key) == -1
      label = key.replace(/\-/g, ' ')
      text.push "<p><strong>#{label}:</strong> #{value}</p>"
  text.join('')

module.exports = class QuestionnaireEmail
  constructor: ->
    @email = new Sendgrid.Email()
    @email.setFrom(from)
    @email.setSubject('New answer')
    @email.addTo(recipients.split(','))
    @email.addHeader('X-Sent-Using', 'SendGrid-API')
    @email.addHeader('X-Transport', 'web')

  send: (answers, callback) ->
    @email.setHtml(jsonToText(answers))

    Sendgrid.send @email, (err, json) ->
      console.log "Error while sending email: #{err}" if err
      callback(error: err, json: json)

